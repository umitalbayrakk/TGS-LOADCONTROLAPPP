import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:load_control/domain/models/flight_record.dart';
import 'package:load_control/utils/colors.dart';
import 'package:load_control/widgets/appBar/custom_app_bar_widgets.dart';
import 'package:load_control/widgets/drawer/custom_drawer_view.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/flight_record_viewmodel.dart';
import '../add_flight_record/add_flight_record_view.dart';
import '../flight_record_details/flight_record_detail_view.dart';
import 'package:intl/intl.dart';

class FlightRecordListView extends StatefulWidget {
  const FlightRecordListView({super.key, required String email});

  @override
  State<FlightRecordListView> createState() => _FlightRecordListViewState();
}

class _FlightRecordListViewState extends State<FlightRecordListView> {
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<FlightRecordViewModel>().loadRecords(),
    );
  }

  List<FlightRecord> _filterRecords(List<FlightRecord> records, String query) {
    if (query.isEmpty) return records;
    final lowercaseQuery = query.toLowerCase();
    return records.where((record) {
      return record.flightInfo.flightNumber.toLowerCase().contains(lowercaseQuery) ||
          record.flightInfo.team.toLowerCase().contains(lowercaseQuery) ||
          record.flightInfo.tailNumber.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  Future<void> _refreshRecords() async {
    await context.read<FlightRecordViewModel>().loadRecords();
  }

// Yükleme Durumları Control Metodu 3 durum var.
  Color _getAvatarColor(FlightRecord record) {
    final cargo = record.cargoInfo;
    if (cargo.cargoFlag.isEmpty &&
        cargo.loadingNumber.isEmpty &&
        cargo.loadingInstructions.isEmpty &&
        cargo.loadPlan.isEmpty) {
      return AppColors.unSelected;
    }
    if (cargo.cargoFlag == 'Takılmamış' ||
        cargo.loadingNumber == 'Yazılmamış' ||
        cargo.loadingInstructions == 'Yapılmamış' ||
        cargo.loadPlan == 'Hayır') {
      return AppColors.greenSpot;
    }
    if (cargo.cargoFlag == 'Takılmış' &&
        cargo.loadingNumber == 'Yazılmış' &&
        cargo.loadingInstructions != 'Yapılmamış' &&
        cargo.loadPlan == 'Evet') {
      return AppColors.snackBarGreen;
    }
    return AppColors.unSelected;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.generalBackground,
      drawer: const CustomDrawer(),
      appBar: AppBarWidgets(
        onSearch: (String query) {
          setState(() {
            _searchQuery = query;
          });
        },
      ),
      body: Consumer<FlightRecordViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading && viewModel.records.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.records.isEmpty) {
            return Center(
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(30),
                  gradient: LinearGradient(
                    colors: [
                      AppColors.searcColor.withOpacity(0.3),
                      AppColors.searcColor.withOpacity(0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(
                    color: AppColors.switchColor.withOpacity(0.9),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.searcColor.withOpacity(0.15),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20),
                width: 400,
                height: 300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      "Henüz Herhangi bir veri listelenemedi",
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                            color: AppColors.switchColor.withOpacity(0.95),
                            letterSpacing: 1.1,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 25),
                    Icon(
                      Icons.list,
                      size: 110,
                      color: AppColors.switchColor.withOpacity(0.9),
                    ),
                  ],
                ),
              ),
            );
          }

          final sortedRecords = viewModel.records..sort((a, b) => b.createdAt.compareTo(a.createdAt));
          final filteredRecords = _filterRecords(sortedRecords, _searchQuery);

          return RefreshIndicator(
            onRefresh: _refreshRecords,
            color: AppColors.snackBarGreen,
            backgroundColor: AppColors.generalBackground,
            child: ListView.builder(
              itemCount: filteredRecords.length,
              itemBuilder: (context, index) {
                final record = filteredRecords[index];
                final dateFormat = DateFormat('dd.MM.yyyy HH:mm');
                final formattedDate = dateFormat.format(record.createdAt);

                return Card(
                  color: AppColors.cardColor,
                  borderOnForeground: true,
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 20,
                      backgroundColor: _getAvatarColor(record),
                      child: Text(
                        (index + 1).toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      'Uçuş Numarası: ${record.flightInfo.flightNumber}',
                      style: const TextStyle(color: AppColors.removeColor, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Ekip: ${record.flightInfo.team}',
                            style: const TextStyle(color: AppColors.borderColor, fontWeight: FontWeight.bold)),
                        Text(
                            'Kuyruk Numara: ${record.flightInfo.tailNumber} | Park: ${record.flightInfo.parkingPosition}',
                            style: const TextStyle(color: AppColors.borderColor, fontWeight: FontWeight.bold)),
                        Text(
                            'Harekat Memuru: ${record.flightInfo.operationsOfficer} | Postabaşı: ${record.flightInfo.postMaster}',
                            style: const TextStyle(color: AppColors.borderColor, fontWeight: FontWeight.bold)),
                        Text(
                          'Ekleme Tarihi : $formattedDate',
                          style: const TextStyle(
                            color: AppColors.removeColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(FeatherIcons.edit),
                          color: AppColors.snackBarGreen,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddFlightRecordView(record: record),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(FeatherIcons.trash),
                          color: AppColors.greenSpot,
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                backgroundColor: AppColors.cardColor,
                                title: const Text('Kaydı Sil'),
                                content: const Text('Kaydı Silmek İstediğnizden Eminmisiniz?'),
                                actions: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.searcColor,
                                    ),
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text(
                                      'İptal',
                                      style: TextStyle(color: AppColors.borderColor),
                                    ),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.greenSpot,
                                    ),
                                    onPressed: () {
                                      viewModel.deleteRecord(record.id);
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      'Sil',
                                      style: TextStyle(color: AppColors.whiteSpot),
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FlightRecordDetailView(record: record),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddFlightRecordView(),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.snackBarRed,
          foregroundColor: AppColors.borderColor.withOpacity(0.2),
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shadowColor: AppColors.searcColor.withOpacity(0.3),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              FeatherIcons.plusCircle,
              color: AppColors.whiteSpot,
            ),
            const SizedBox(width: 8),
            const Text(
              "Kayıt Ekle",
              style: TextStyle(
                color: AppColors.whiteSpot,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
