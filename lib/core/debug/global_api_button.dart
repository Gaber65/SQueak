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
			backgroundColor: Colors.grey[50],
			appBar: AppBar(
				elevation: 0,
				title: const Text('API Tester'),
				actions: [
					if (calls.isNotEmpty)
						IconButton(
							icon: const Icon(Icons.delete_outline),
							onPressed: () => logger.clear(),
							tooltip: 'Clear all',
						)
				],
			),
			body: calls.isEmpty
					? Center(
							child: Column(
								mainAxisAlignment: MainAxisAlignment.center,
								children: [
									Icon(Icons.api, size: 64, color: Colors.grey[400]),
									const SizedBox(height: 16),
									Text(
										'No API calls yet',
										style: TextStyle(fontSize: 16, color: Colors.grey[600]),
									),
								],
							),
						)
					: ListView.builder(
							padding: const EdgeInsets.all(12),
							itemCount: calls.length,
							itemBuilder: (context, index) {
								final call = calls[index];
								final status = call.statusCode;
								final color = _getStatusColor(status);

								return Padding(
									padding: const EdgeInsets.only(bottom: 8),
									child: Material(
										color: Colors.white,
										borderRadius: BorderRadius.circular(12),
										elevation: 0,
										child: InkWell(
											borderRadius: BorderRadius.circular(12),
											onTap: () => Navigator.of(context).push(
												MaterialPageRoute(builder: (_) => ApiCallDetail(call: call)),
											),
											child: Padding(
												padding: const EdgeInsets.all(16),
												child: Column(
													crossAxisAlignment: CrossAxisAlignment.start,
													children: [
														Row(
															children: [
																Container(
																	padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
																	decoration: BoxDecoration(
																		color: color.withOpacity(0.1),
																		borderRadius: BorderRadius.circular(6),
																	),
																	child: Text(
																		call.method,
																		style: TextStyle(
																			color: color,
																			fontWeight: FontWeight.w600,
																			fontSize: 12,
																		),
																	),
																),
																const SizedBox(width: 12),
																if (status != null)
																	Container(
																		padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
																		decoration: BoxDecoration(
																			color: color.withOpacity(0.1),
																			borderRadius: BorderRadius.circular(4),
																		),
																		child: Text(
																			status.toString(),
																			style: TextStyle(
																				color: color,
																				fontWeight: FontWeight.w600,
																				fontSize: 11,
																			),
																		),
																	),
																const Spacer(),
																Icon(Icons.chevron_right, color: Colors.grey[400], size: 20),
															],
														),
														const SizedBox(height: 12),
														Text(
															call.url,
															style: const TextStyle(
																fontSize: 14,
																fontWeight: FontWeight.w500,
															),
															maxLines: 2,
															overflow: TextOverflow.ellipsis,
														),
														const SizedBox(height: 8),
														Row(
															children: [
																Icon(Icons.access_time, size: 14, color: Colors.grey[500]),
																const SizedBox(width: 4),
																Text(
																	call.timestamp.toString(),
																	style: TextStyle(fontSize: 12, color: Colors.grey[600]),
																),
																const SizedBox(width: 16),
																Icon(Icons.timer, size: 14, color: Colors.grey[500]),
																const SizedBox(width: 4),
																Text(
																	'${call.duration?.inMilliseconds ?? '-'} ms',
																	style: TextStyle(fontSize: 12, color: Colors.grey[600]),
																),
															],
														),
													],
												),
											),
										),
									),
								);
							},
						),
		);
	}

	Color _getStatusColor(int? status) {
		if (status == null) return Colors.grey;
		if (status >= 200 && status < 300) return Colors.green;
		if (status >= 400) return Colors.red;
		return Colors.orange;
	}
}

class ApiCallDetail extends StatelessWidget {
	final ApiCall call;

	const ApiCallDetail({super.key, required this.call});

	@override
	Widget build(BuildContext context) {
		final status = call.statusCode;
		final color = _getStatusColor(status);

		return Scaffold(
			backgroundColor: Colors.grey[50],
			appBar: AppBar(
				elevation: 0,
				title: const Text('API Call Details'),
			),
			body: SingleChildScrollView(
				padding: const EdgeInsets.all(16),
				child: Column(
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
						_buildCard(
							child: Column(
								crossAxisAlignment: CrossAxisAlignment.start,
								children: [
									Row(
										children: [
											Container(
												padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
												decoration: BoxDecoration(
													color: color.withOpacity(0.1),
													borderRadius: BorderRadius.circular(6),
												),
												child: Text(
													call.method,
													style: TextStyle(
														color: color,
														fontWeight: FontWeight.w600,
														fontSize: 13,
													),
												),
											),
											const SizedBox(width: 12),
											if (status != null)
												Container(
													padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
													decoration: BoxDecoration(
														color: color.withOpacity(0.1),
														borderRadius: BorderRadius.circular(6),
													),
													child: Text(
														status.toString(),
														style: TextStyle(
															color: color,
															fontWeight: FontWeight.w600,
															fontSize: 13,
														),
													),
												),
										],
									),
									const SizedBox(height: 16),
									const Text(
										'URL',
										style: TextStyle(
											fontSize: 12,
											fontWeight: FontWeight.w600,
											color: Colors.grey,
										),
									),
									const SizedBox(height: 6),
									SelectableText(
										call.url,
										style: const TextStyle(fontSize: 14),
									),
									const SizedBox(height: 16),
									Row(
										children: [
											Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
											const SizedBox(width: 6),
											Text(
												call.timestamp.toString(),
												style: TextStyle(fontSize: 13, color: Colors.grey[700]),
											),
											const SizedBox(width: 20),
											Icon(Icons.timer, size: 16, color: Colors.grey[600]),
											const SizedBox(width: 6),
											Text(
												'${call.duration?.inMilliseconds ?? '-'} ms',
												style: TextStyle(fontSize: 13, color: Colors.grey[700]),
											),
										],
									),
								],
							),
						),
						const SizedBox(height: 16),
						_buildSection('Request', [
							_buildDataRow('Headers', call.requestHeaders),
							const SizedBox(height: 12),
							_buildDataRow('Body', call.requestBody),
						]),
						const SizedBox(height: 16),
						_buildSection('Response', [
							_buildDataRow('Headers', call.responseHeaders),
							const SizedBox(height: 12),
							_buildDataRow('Body', call.responseBody),
						]),
					],
				),
			),
		);
	}

	Widget _buildCard({required Widget child}) {
		return Container(
			width: double.infinity,
			padding: const EdgeInsets.all(16),
			decoration: BoxDecoration(
				color: Colors.white,
				borderRadius: BorderRadius.circular(12),
			),
			child: child,
		);
	}

	Widget _buildSection(String title, List<Widget> children) {
		return Column(
			crossAxisAlignment: CrossAxisAlignment.start,
			children: [
				Padding(
					padding: const EdgeInsets.only(left: 4, bottom: 8),
					child: Text(
						title,
						style: const TextStyle(
							fontSize: 16,
							fontWeight: FontWeight.w600,
						),
					),
				),
				_buildCard(
					child: Column(
						crossAxisAlignment: CrossAxisAlignment.start,
						children: children,
					),
				),
			],
		);
	}

	Widget _buildDataRow(String label, dynamic data) {
		final hasData = data != null && data.toString().isNotEmpty;
		
		return Column(
			crossAxisAlignment: CrossAxisAlignment.start,
			children: [
				Text(
					label,
					style: const TextStyle(
						fontSize: 12,
						fontWeight: FontWeight.w600,
						color: Colors.grey,
					),
				),
				const SizedBox(height: 6),
				Container(
					width: double.infinity,
					padding: const EdgeInsets.all(12),
					decoration: BoxDecoration(
						color: Colors.grey[100],
						borderRadius: BorderRadius.circular(8),
					),
					child: SelectableText(
						hasData ? data.toString() : 'No data',
						style: TextStyle(
							fontSize: 13,
							fontFamily: 'monospace',
							color: hasData ? Colors.black87 : Colors.grey[500],
						),
					),
				),
			],
		);
	}

	Color _getStatusColor(int? status) {
		if (status == null) return Colors.grey;
		if (status >= 200 && status < 300) return Colors.green;
		if (status >= 400) return Colors.red;
		return Colors.orange;
	}
}