import 'package:flutter/foundation.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:squeak/core/service/cache/shared_preferences/cache_helper.dart';

/// خدمة SignalR للتواصل الفوري عبر ChatHub
/// تدير الاتصال والرسائل بشكل نظيف ومنظم
class SignalRService {
  // ============================================
  // المتغيرات الأساسية
  // ============================================
  
  /// عنوان خادم SignalR الخاص بالدردشة
  static const String _hubUrl = 'https://squeakapi.veticareapp.com:8001/chathub';
  
  /// كائن الاتصال الرئيسي
  HubConnection? _hubConnection;
  
  /// حالة الاتصال الحالية
  HubConnectionState get connectionState => 
      _hubConnection?.state ?? HubConnectionState.Disconnected;
  
  /// هل الاتصال نشط؟
  bool get isConnected => connectionState == HubConnectionState.Connected;
  
  /// Singleton pattern للحفاظ على نسخة واحدة
  static final SignalRService _instance = SignalRService._internal();
  factory SignalRService() => _instance;
  SignalRService._internal();

  // ============================================
  // إنشاء وفتح الاتصال
  // ============================================
  
  /// فتح اتصال جديد مع الخادم باستخدام التوكن
  Future<void> connect() async {
    try {
      debugPrint('🔵 SignalR: بدء الاتصال بالخادم...');
      
      // الحصول على التوكن من الذاكرة المحلية
      final token = CacheHelper.getData('token');
      
      if (token == null || token.toString().isEmpty) {
        debugPrint('❌ SignalR: لا يوجد توكن - الاتصال ملغى');
        return;
      }
      
      debugPrint('✅ SignalR: تم العثور على التوكن');
      
      // إذا كان هناك اتصال سابق نشط، لا حاجة لإعادة الاتصال
      if (_hubConnection != null && isConnected) {
        debugPrint('✅ SignalR: الاتصال نشط بالفعل - لا حاجة لإعادة الاتصال');
        return;
      }
      
      // إذا كان هناك اتصال سابق غير نشط، نغلقه أولاً
      if (_hubConnection != null && !isConnected) {
        debugPrint('🔄 SignalR: إغلاق الاتصال القديم...');
        await disconnect();
      }
      
      // إنشاء الاتصال الجديد مع إعدادات محسّنة
      debugPrint('🔧 SignalR: إنشاء كائن الاتصال...');
      _hubConnection = HubConnectionBuilder()
          .withUrl(
            _hubUrl,
            options: HttpConnectionOptions(
              accessTokenFactory: () async => token.toString(),
              // زيادة وقت الانتظار إلى 30 ثانية
              requestTimeout: 30000,
              // تفعيل الضغط لتسريع نقل البيانات
              skipNegotiation: false,
              // استخدام WebSockets كأولوية
              transport: HttpTransportType.WebSockets,
            ),
          )
          .withAutomaticReconnect(
            retryDelays: [
              0, // محاولة فورية
              2000, // بعد ثانيتين
              5000, // بعد 5 ثوانٍ
              10000, // بعد 10 ثوانٍ
              30000, // بعد 30 ثانية
            ],
          )
          .build();
      
      // تسجيل أحداث الاتصال
      _registerConnectionEvents();
      
      // بدء الاتصال مع معالجة الأخطاء
      debugPrint('🚀 SignalR: محاولة الاتصال بالخادم...');
      debugPrint('⏱️ SignalR: وقت الانتظار الأقصى: 30 ثانية');
      
      await _hubConnection!.start();
      
      debugPrint('✅ SignalR: تم الاتصال بنجاح!');
      debugPrint('📊 SignalR: حالة الاتصال: ${connectionState.toString()}');
      debugPrint('🆔 SignalR: معرف الاتصال: ${connectionId ?? "غير متاح"}');
      
    } catch (e) {
      debugPrint('❌ SignalR: فشل الاتصال - $e');
      
      // تحليل نوع الخطأ وإعطاء نصائح
      if (e.toString().contains('TimeoutException')) {
        debugPrint('⚠️ SignalR: الخادم لا يستجيب - تحقق من:');
        debugPrint('   1. الاتصال بالإنترنت');
        debugPrint('   2. صحة عنوان الخادم: $_hubUrl');
        debugPrint('   3. أن الخادم يعمل بشكل صحيح');
      } else if (e.toString().contains('SocketException')) {
        debugPrint('⚠️ SignalR: مشكلة في الشبكة - تحقق من الاتصال بالإنترنت');
      }
      
      rethrow;
    }
  }

  // ============================================
  // تسجيل أحداث الاتصال
  // ============================================
  
  /// تسجيل الاستماع لأحداث الاتصال المختلفة
  void _registerConnectionEvents() {
    if (_hubConnection == null) return;
    
    // عند إغلاق الاتصال
    _hubConnection!.onclose(({error}) {
      debugPrint('🔴 SignalR: تم إغلاق الاتصال');
      if (error != null) {
        debugPrint('❌ SignalR: سبب الإغلاق: $error');
      }
    });
    
    // عند إعادة الاتصال
    _hubConnection!.onreconnecting(({error}) {
      debugPrint('🔄 SignalR: جارٍ إعادة الاتصال...');
      if (error != null) {
        debugPrint('⚠️ SignalR: سبب الانقطاع: $error');
      }
    });
    
    // عند نجاح إعادة الاتصال
    _hubConnection!.onreconnected(({connectionId}) {
      debugPrint('✅ SignalR: تمت إعادة الاتصال بنجاح!');
      debugPrint('🆔 SignalR: معرف الاتصال الجديد: $connectionId');
    });
  }

  // ============================================
  // إرسال رسالة للمستخدم
  // ============================================
  
  /// إرسال رسالة إلى مستخدم آخر عبر SignalR
  /// 
  /// [command] يحتوي على كل بيانات الرسالة:
  /// - description: نص الرسالة
  /// - image: رابط الصورة (اختياري)
  /// - video: رابط الفيديو (اختياري)
  /// - audio: رابط الصوت (اختياري)
  /// - toUserId: معرف المستخدم المستقبل
  /// - conversationId: معرف المحادثة
  /// - fromPetId: معرف حيوان المرسل
  /// - toPetId: معرف حيوان المستقبل
  Future<void> sendMessageToUser(Map<String, dynamic> command) async {
    try {
      debugPrint('📤 SignalR: محاولة إرسال رسالة...');
      
      // التحقق من الاتصال
      if (!isConnected) {
        debugPrint('❌ SignalR: الاتصال غير نشط - جارٍ إعادة الاتصال...');
        await connect();
      }
      
      // طباعة بيانات الرسالة للتوضيح
      debugPrint('📋 SignalR: بيانات الرسالة:');
      debugPrint('   - النص: ${command['description']}');
      debugPrint('   - معرف المحادثة: ${command['conversationId']}');
      debugPrint('   - من المستخدم: ${command['fromUserId']}');
      debugPrint('   - إلى المستخدم: ${command['toUserId']}');
      debugPrint('   - من الحيوان: ${command['fromPetId']}');
      debugPrint('   - إلى الحيوان: ${command['toPetId']}');
      
      // محاولة أسماء الدوال المختلفة
      const methodNames = [
        'SenMessageToUser',  // من المثال المعطى (مع خطأ إملائي)
        'SendMessageToUser', // الاسم الصحيح
        'SendMessage',       // اسم مختصر
        'sendMessage',       // camelCase
      ];
      
      bool success = false;
      String? lastError;
      
      for (final methodName in methodNames) {
        try {
          debugPrint('🔄 SignalR: محاولة استدعاء: $methodName');
          await _hubConnection!.invoke(methodName, args: [command]);
          debugPrint('✅ SignalR: تم إرسال الرسالة بنجاح عبر: $methodName');
          success = true;
          break;
        } catch (e) {
          lastError = e.toString();
          debugPrint('⚠️ SignalR: فشل $methodName - $e');
          continue;
        }
      }
      
      if (!success) {
        debugPrint('❌ SignalR: فشلت جميع المحاولات. آخر خطأ: $lastError');
        throw Exception('فشل إرسال الرسالة عبر جميع أسماء الدوال المتاحة');
      }
      
    } catch (e) {
      debugPrint('❌ SignalR: فشل إرسال الرسالة - $e');
      rethrow;
    }
  }

  // ============================================
  // استقبال الرسائل
  // ============================================
  
  /// الاستماع للرسائل الواردة من الخادم
  /// 
  /// [methodName] اسم الدالة التي نستمع لها (مثل: "ReceiveMessage")
  /// [callback] الدالة التي تنفذ عند وصول رسالة جديدة
  void onMessageReceived(String methodName, Function(List<Object?>?) callback) {
    if (_hubConnection == null) {
      debugPrint('❌ SignalR: لا يوجد اتصال للاستماع');
      return;
    }
    
    debugPrint('👂 SignalR: بدء الاستماع للرسائل عبر: $methodName');
    
    _hubConnection!.on(methodName, (arguments) {
      debugPrint('📨 SignalR: رسالة واردة من الخادم!');
      debugPrint('📦 SignalR: البيانات: $arguments');
      callback(arguments);
    });
  }

  // ============================================
  // إغلاق الاتصال
  // ============================================
  
  /// إغلاق الاتصال بالخادم
  Future<void> disconnect() async {
    try {
      if (_hubConnection == null) {
        debugPrint('⚠️ SignalR: لا يوجد اتصال للإغلاق');
        return;
      }
      
      debugPrint('🔴 SignalR: جارٍ إغلاق الاتصال...');
      await _hubConnection!.stop();
      _hubConnection = null;
      debugPrint('✅ SignalR: تم إغلاق الاتصال بنجاح');
      
    } catch (e) {
      debugPrint('❌ SignalR: خطأ أثناء إغلاق الاتصال - $e');
      _hubConnection = null;
    }
  }

  // ============================================
  // دوال مساعدة
  // ============================================
  
  /// الحصول على معرف الاتصال الحالي
  String? get connectionId => _hubConnection?.connectionId;
  
  /// التحقق من حالة الاتصال
  void checkConnection() {
    debugPrint('📊 SignalR: حالة الاتصال الحالية:');
    debugPrint('   - متصل: $isConnected');
    debugPrint('   - الحالة: ${connectionState.toString()}');
    debugPrint('   - معرف الاتصال: ${connectionId ?? 'غير متاح'}');
  }
}
