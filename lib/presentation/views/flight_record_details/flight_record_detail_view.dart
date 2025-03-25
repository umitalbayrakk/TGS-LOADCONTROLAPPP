import 'package:flutter/material.dart';
import 'package:load_control/utils/colors.dart';
import 'dart:io';
import '../../../domain/models/flight_record.dart';

class FlightRecordDetailView extends StatelessWidget {
  final FlightRecord record;

  const FlightRecordDetailView({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.generalBackground,
      appBar: AppBar(
        
        iconTheme: const IconThemeData(
          
          color: AppColors.whiteSpot,
        ),
        backgroundColor: AppColors.snackBarRed,
        title: Text(
          'Uçuş ${record.flightInfo.flightNumber} Detay Sayfası',
          style: const TextStyle(
            color: AppColors.whiteSpot,
            fontSize: 30,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Card(
              color: AppColors.cardColor,
              child: Column(
                children: [
                  const ListTile(
                    title: Text(
                      'Uçuş Bilgileri',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text('Ekip : ${record.flightInfo.team}'),
                  ),
                  ListTile(
                    title: Text('Uçuş No : ${record.flightInfo.flightNumber}'),
                  ),
                  ListTile(
                    title: Text('Kuyruk : ${record.flightInfo.tailNumber}'),
                  ),
                  ListTile(
                    title: Text('Park : ${record.flightInfo.parkingPosition}'),
                  ),
                  ListTile(
                    title: Text('Harekat Memuru : ${record.flightInfo.operationsOfficer}'),
                  ),
                  ListTile(
                    title: Text('Postabaşı : ${record.flightInfo.postMaster}'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Card(
                color: AppColors.cardColor,
                child: Column(
                  children: [
                    const ListTile(
                      title: Text(
                        'Kargo & Yükleme Bilgileri',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ListTile(
                      title: Text('Kargo Flaması : ${record.cargoInfo.cargoFlag}'),
                    ),
                    ListTile(
                      title: Text('Yükleme Numarası : ${record.cargoInfo.loadingNumber}'),
                    ),
                    ListTile(
                      title: Text('Yükleme Talimatları : ${record.cargoInfo.loadingInstructions}'),
                    ),
                    ListTile(
                      title: Text('Yükleme Değişikliği : ${record.cargoInfo.loadingChange}'),
                    ),
                    ListTile(
                      title: Text('1.Load Plan ve 2.Load Plan Sicil-imza-saat : ${record.cargoInfo.loadPlan}'),
                    ),
                    ListTile(
                      title: Text('2.Load plan loadsheet alınmadan Teslim : ${record.cargoInfo.loadPlanDelivery}'),
                    ),
                    ListTile(
                      title: Text('Loadsheet-Loadplan Uygunluğu : ${record.cargoInfo.loadPageCompatibility}'),
                    ),
                  ],
                )),
            const SizedBox(height: 24),
            Card(
                color: AppColors.cardColor,
                child: ListTile(
                  title: _buildSection(
                    'Notlar',
                    [
                      Text(record.note.content),
                    ],
                  ),
                )),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Card(
                  color: AppColors.cardColor,
                  child: Column(
                    children: [
                      if (record.images.isNotEmpty) ...[
                        const SizedBox(height: 24),
                        _buildSection(
                          'Fotoğraf',
                          [
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                              ),
                              itemCount: record.images.length,
                              itemBuilder: (context, index) {
                                return Image.file(
                                  File(record.images[index].imagePath),
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }
}
