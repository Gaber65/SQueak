import 'package:flutter/material.dart';
import 'api_logger.dart';

class ApiTesterScreen extends StatefulWidget {
	const ApiTesterScreen({super.key});

	@override
	State<ApiTesterScreen> createState() => _ApiTesterScreenState();
}

class _ApiTesterScreenState extends State<ApiTesterScreen> {
	final logger = ApiLogger.instance;

	@override
	void initState() {
		super.initState();
		logger.addListener(_onCallsUpdate);
	}

	@override
	void dispose() {
		logger.removeListener(_onCallsUpdate);
		super.dispose();
	}

	void _onCallsUpdate() => setState(() {});

	@override
	Widget build(BuildContext context) {
		final calls = logger.calls;
		return Scaffold(
			appBar: AppBar(
				title: const Text('API Tester'),
				actions: [
					IconButton(
						icon: const Icon(Icons.delete_forever),
						onPressed: () => logger.clear(),
						tooltip: 'Clear',
					)
				],
			),
			body: calls.isEmpty
					? const Center(child: Text('No API calls captured yet'))
					: ListView.separated(
							itemCount: calls.length,
							separatorBuilder: (_, __) => const Divider(height: 1),
							itemBuilder: (context, index) {
								final call = calls[index];
								final status = call.statusCode;
								final color = (status != null && status >= 200 && status < 300)
										? Colors.green
										: (status != null && status >= 400)
												? Colors.red
												: Colors.orange;

								return ListTile(
									leading: Container(
										padding: const EdgeInsets.all(6),
										decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(6)),
										child: Text(call.method, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
									),
									title: Text(call.url, maxLines: 1, overflow: TextOverflow.ellipsis),
									subtitle: Text('${call.timestamp} • ${call.duration?.inMilliseconds ?? '-'} ms'),
									trailing: status != null ? Text(status.toString(), style: TextStyle(color: color, fontWeight: FontWeight.bold)) : null,
									onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => ApiCallDetail(call: call))),
								);
							},
						),
		);
	}
}

class ApiCallDetail extends StatelessWidget {
	final ApiCall call;

	const ApiCallDetail({super.key, required this.call});

	Widget _buildSection(String title, Widget child) {
		return Padding(
			padding: const EdgeInsets.symmetric(vertical: 8.0),
			child: Column(
				crossAxisAlignment: CrossAxisAlignment.start,
				children: [
					Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
					const SizedBox(height: 6),
					child,
				],
			),
		);
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(title: const Text('API Detail')),
			body: Padding(
				padding: const EdgeInsets.all(12.0),
				child: SingleChildScrollView(
					child: Column(
						crossAxisAlignment: CrossAxisAlignment.start,
						children: [
							Text(call.url, style: const TextStyle(fontWeight: FontWeight.bold)),
							const SizedBox(height: 10),
							_buildSection('Request', Column(
								crossAxisAlignment: CrossAxisAlignment.start,
								children: [
									Text('Method: ${call.method}'),
									const SizedBox(height: 6),
									Text('Headers:'),
									SelectableText(call.requestHeaders?.toString() ?? '-'),
									const SizedBox(height: 6),
									Text('Body:'),
									SelectableText(call.requestBody?.toString() ?? '-'),
								],
							)),
							_buildSection('Response', Column(
								crossAxisAlignment: CrossAxisAlignment.start,
								children: [
									Text('Status: ${call.statusCode ?? '-'}'),
									const SizedBox(height: 6),
									Text('Headers:'),
									SelectableText(call.responseHeaders?.toString() ?? '-'),
									const SizedBox(height: 6),
									Text('Body:'),
									SelectableText(call.responseBody?.toString() ?? '-'),
								],
							)),
							const SizedBox(height: 20),
							Text('Captured at ${call.timestamp}'),
						],
					),
				),
			),
		);
	}
}

