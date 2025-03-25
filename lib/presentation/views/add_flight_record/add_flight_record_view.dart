import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:load_control/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../viewmodels/flight_record_viewmodel.dart';
import '../../../domain/models/flight_record.dart';
import '../../../domain/models/flight_info.dart';
import '../../../domain/models/cargo_info.dart';
import '../../../domain/models/note.dart';
import '../../../domain/models/image.dart';
import '../../../services/image_service.dart';

class AddFlightRecordView extends StatefulWidget {
  final FlightRecord? record;

  const AddFlightRecordView({super.key, this.record});

  @override
  State<AddFlightRecordView> createState() => _AddFlightRecordViewState();
}

class _AddFlightRecordViewState extends State<AddFlightRecordView> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _teamController;
  late TextEditingController _flightNumberController;
  late TextEditingController _tailNumberController;
  late TextEditingController _parkingPositionController;
  late TextEditingController _operationsOfficerController;
  late TextEditingController _postMasterController;

  late TextEditingController _cargoFlagController;
  late TextEditingController _loadingNumberController;
  late TextEditingController _loadingInstructionsController;
  late TextEditingController _loadingChangeController;
  late TextEditingController _loadPlanController;
  late TextEditingController _loadPlanDeliveryController;
  late TextEditingController _loadPageCompatibilityController;

  late TextEditingController _noteController;
  List<String> _imagePaths = [];
  final _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);

    _teamController = TextEditingController(text: widget.record?.flightInfo.team ?? '');
    _flightNumberController = TextEditingController(text: widget.record?.flightInfo.flightNumber ?? '');
    _tailNumberController = TextEditingController(text: widget.record?.flightInfo.tailNumber ?? '');
    _parkingPositionController = TextEditingController(text: widget.record?.flightInfo.parkingPosition ?? '');
    _operationsOfficerController = TextEditingController(text: widget.record?.flightInfo.operationsOfficer ?? '');
    _postMasterController = TextEditingController(text: widget.record?.flightInfo.postMaster ?? '');

    _cargoFlagController = TextEditingController(text: widget.record?.cargoInfo.cargoFlag ?? '');
    _loadingNumberController = TextEditingController(text: widget.record?.cargoInfo.loadingNumber ?? '');
    _loadingInstructionsController = TextEditingController(text: widget.record?.cargoInfo.loadingInstructions ?? '');
    _loadingChangeController = TextEditingController(text: widget.record?.cargoInfo.loadingChange ?? '');
    _loadPlanController = TextEditingController(text: widget.record?.cargoInfo.loadPlan ?? '');
    _loadPlanDeliveryController = TextEditingController(text: widget.record?.cargoInfo.loadPlanDelivery ?? '');
    _loadPageCompatibilityController =
        TextEditingController(text: widget.record?.cargoInfo.loadPageCompatibility ?? '');

    _noteController = TextEditingController(text: widget.record?.note.content ?? '');
    _imagePaths = widget.record?.images.map((img) => img.imagePath).toList() ?? [];
  }

  @override
  void dispose() {
    _tabController.dispose();
    _teamController.dispose();
    _flightNumberController.dispose();
    _tailNumberController.dispose();
    _parkingPositionController.dispose();
    _operationsOfficerController.dispose();
    _postMasterController.dispose();
    _cargoFlagController.dispose();
    _loadingNumberController.dispose();
    _loadingInstructionsController.dispose();
    _loadingChangeController.dispose();
    _loadPlanController.dispose();
    _loadPlanDeliveryController.dispose();
    _loadPageCompatibilityController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        final savedPath = await ImageService.saveImage(File(image.path));
        setState(() {
          _imagePaths.add(savedPath);
        });
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  void _removeImage(int index) {
    setState(() {
      _imagePaths.removeAt(index);
    });
  }

  bool _isInfoTabFilled() {
    return _teamController.text.isNotEmpty &&
        _flightNumberController.text.isNotEmpty &&
        _tailNumberController.text.isNotEmpty &&
        _parkingPositionController.text.isNotEmpty &&
        _operationsOfficerController.text.isNotEmpty &&
        _postMasterController.text.isNotEmpty;
  }

  void _saveRecord() {
    if (_formKey.currentState!.validate()) {
      int currentTab = _tabController.index;

      if (currentTab == 0 && !_isInfoTabFilled()) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Lütfen mevcut sekmeyi tamamlayın'),
            backgroundColor: AppColors.greenSpot,
          ),
        );
        return;
      }

      if (currentTab == 0 && _isInfoTabFilled()) {
        _tabController.animateTo(1);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Başarılı Bir Şekilde Kaydedildi'),
            backgroundColor: AppColors.snackBarGreen,
          ),
        );
        return;
      } else if (currentTab == 1) {
        _tabController.animateTo(2);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Başarılı Bir Şekilde Kaydedildi'),
            backgroundColor: AppColors.snackBarGreen,
          ),
        );
        return;
      } else if (currentTab == 2) {
        _tabController.animateTo(3);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Başarılı Bir Şekilde Kaydedildi'),
            backgroundColor: AppColors.snackBarGreen,
          ),
        );
        return;
      }

      if (_isInfoTabFilled()) {
        final flightInfo = FlightInfo(
          id: widget.record?.flightInfo.id ?? DateTime.now().toString(),
          team: _teamController.text,
          flightNumber: _flightNumberController.text,
          tailNumber: _tailNumberController.text,
          parkingPosition: _parkingPositionController.text,
          operationsOfficer: _operationsOfficerController.text,
          postMaster: _postMasterController.text,
          createdAt: DateTime.now(),
        );

        final cargoInfo = CargoInfo(
          id: widget.record?.cargoInfo.id ?? DateTime.now().toString(),
          cargoFlag: _cargoFlagController.text,
          loadingNumber: _loadingNumberController.text,
          loadingInstructions: _loadingInstructionsController.text,
          loadingChange: _loadingChangeController.text,
          loadPlan: _loadPlanController.text,
          loadPlanDelivery: _loadPlanDeliveryController.text,
          loadPageCompatibility: _loadPageCompatibilityController.text,
          createdAt: DateTime.now(),
        );

        final note = Note(
          id: widget.record?.note.id ?? DateTime.now().toString(),
          content: _noteController.text,
          createdAt: DateTime.now(),
        );

        final images = _imagePaths
            .map((path) => ImageModel(
                  id: DateTime.now().toString(),
                  imagePath: path,
                  createdAt: DateTime.now(),
                ))
            .toList();

        final record = FlightRecord(
          id: widget.record?.id ?? DateTime.now().toString(),
          flightInfo: flightInfo,
          cargoInfo: cargoInfo,
          note: note,
          images: images,
          createdAt: DateTime.now(),
        );

        if (widget.record != null) {
          context.read<FlightRecordViewModel>().updateRecord(record);
        } else {
          context.read<FlightRecordViewModel>().addRecord(record);
        }
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.generalBackground,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppColors.whiteSpot),
        backgroundColor: AppColors.snackBarRed,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.record != null ? 'Kayıt Güncelle' : 'Yeni Kayıt',
              style: const TextStyle(color: AppColors.whiteSpot, fontWeight: FontWeight.bold),
            ),
            Image.asset(
              "assets/tgs.png",
              height: 50,
              width: 100,
            ),
          ],
        ),
        bottom: TabBar(
          indicator: const BoxDecoration(
            color: AppColors.switchColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          indicatorColor: Colors.white,
          controller: _tabController,
          unselectedLabelColor: AppColors.switchColor,
          tabs: const [
            Tab(icon: Icon(FeatherIcons.info, color: AppColors.whiteSpot, size: 40)),
            Tab(icon: Icon(FeatherIcons.checkSquare, color: AppColors.whiteSpot, size: 40)),
            Tab(icon: Icon(FeatherIcons.messageCircle, color: AppColors.whiteSpot, size: 40)),
            Tab(icon: Icon(FeatherIcons.camera, color: AppColors.whiteSpot, size: 40)),
          ],
        ),
      ),
      body: Form(
        key: _formKey,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildInfoTab(),
                _buildCargoTab(),
                _buildNotesTab(),
                _buildImagesTab(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _saveRecord,
        backgroundColor: AppColors.snackBarRed,
        icon: const Icon(FeatherIcons.file, color: AppColors.whiteSpot),
        label: const Text(
          "Kaydet",
          style: TextStyle(
            color: AppColors.whiteSpot,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          DropdownButtonFormField<String>(
            dropdownColor: AppColors.cardColor,
            value: _teamController.text.isEmpty ? null : _teamController.text,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Ekip',
            ),
            items: const [
              DropdownMenuItem(value: 'A', child: Text('A')),
              DropdownMenuItem(value: 'B', child: Text('B')),
              DropdownMenuItem(value: 'C', child: Text('C')),
              DropdownMenuItem(value: 'D', child: Text('D')),
              DropdownMenuItem(value: 'E', child: Text('E')),
              DropdownMenuItem(value: 'F', child: Text('F')),
            ],
            onChanged: (value) => _teamController.text = value ?? '',
            validator: (value) => value == null ? 'Please select a team' : null,
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _flightNumberController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Uçuş No',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a flight number';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          DropdownButtonFormField<String>(
            dropdownColor: AppColors.cardColor,
            value: _tailNumberController.text.isEmpty ? null : _tailNumberController.text,
            decoration: const InputDecoration(
              labelText: 'Kuruk No',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(value: 'TN001', child: Text('TN001')),
              DropdownMenuItem(value: 'TN002', child: Text('TN002')),
              DropdownMenuItem(value: 'TN003', child: Text('TN003')),
              DropdownMenuItem(value: 'TN004', child: Text('TN004')),
              DropdownMenuItem(value: 'TN005', child: Text('TN005')),
              DropdownMenuItem(value: 'TN006', child: Text('TN006')),
              DropdownMenuItem(value: 'TN007', child: Text('TN007')),
              DropdownMenuItem(value: 'TN008', child: Text('TN008')),
              DropdownMenuItem(value: 'TN009', child: Text('TN009')),
              DropdownMenuItem(value: 'TN010', child: Text('TN010')),
              DropdownMenuItem(value: 'TN011', child: Text('TN011')),
              DropdownMenuItem(value: 'TN012', child: Text('TN012')),
              DropdownMenuItem(value: 'TN013', child: Text('TN013')),
              DropdownMenuItem(value: 'TN014', child: Text('TN014')),
              DropdownMenuItem(value: 'TN015', child: Text('TN015')),
            ],
            onChanged: (value) => _tailNumberController.text = value ?? '',
            validator: (value) => value == null ? 'Please select a tail number' : null,
          ),
          const SizedBox(height: 20),
          DropdownButtonFormField<String>(
            dropdownColor: AppColors.cardColor,
            value: _parkingPositionController.text.isEmpty ? null : _parkingPositionController.text,
            decoration: const InputDecoration(
              labelText: 'Park',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(value: 'PP001', child: Text('PP001')),
              DropdownMenuItem(value: 'PP002', child: Text('PP002')),
              DropdownMenuItem(value: 'PP003', child: Text('PP003')),
              DropdownMenuItem(value: 'PP004', child: Text('PP004')),
              DropdownMenuItem(value: 'PP005', child: Text('PP005')),
              DropdownMenuItem(value: 'PP006', child: Text('PP006')),
              DropdownMenuItem(value: 'PP007', child: Text('PP007')),
              DropdownMenuItem(value: 'PP008', child: Text('PP008')),
              DropdownMenuItem(value: 'PP009', child: Text('PP009')),
              DropdownMenuItem(value: 'PP010', child: Text('PP010')),
              DropdownMenuItem(value: 'PP011', child: Text('PP011')),
              DropdownMenuItem(value: 'PP012', child: Text('PP012')),
              DropdownMenuItem(value: 'PP013', child: Text('PP013')),
              DropdownMenuItem(value: 'PP014', child: Text('PP014')),
              DropdownMenuItem(value: 'PP015', child: Text('PP015')),
            ],
            onChanged: (value) => _parkingPositionController.text = value ?? '',
            validator: (value) => value == null ? 'Please select a parking position' : null,
          ),
          const SizedBox(height: 20),
          DropdownButtonFormField<String>(
            dropdownColor: AppColors.cardColor,
            value: _operationsOfficerController.text.isEmpty ? null : _operationsOfficerController.text,
            decoration: const InputDecoration(labelText: 'Harekat Memuru', border: OutlineInputBorder()),
            items: const [
              DropdownMenuItem(value: 'Ahmet Yılmaz', child: Text('Ahmet Yılmaz')),
              DropdownMenuItem(value: 'Mehmet Kaya', child: Text('Mehmet Kaya')),
              DropdownMenuItem(value: 'Ayşe Demir', child: Text('Ayşe Demir')),
              DropdownMenuItem(value: 'Fatma Şahin', child: Text('Fatma Şahin')),
              DropdownMenuItem(value: 'Hasan Çelik', child: Text('Hasan Çelik')),
              DropdownMenuItem(value: 'Zeynep Arslan', child: Text('Zeynep Arslan')),
              DropdownMenuItem(value: 'Murat Koç', child: Text('Murat Koç')),
              DropdownMenuItem(value: 'Emine Özkan', child: Text('Emine Özkan')),
              DropdownMenuItem(value: 'Ali Türkmen', child: Text('Ali Türkmen')),
              DropdownMenuItem(value: 'Elif Doğan', child: Text('Elif Doğan')),
              DropdownMenuItem(value: 'Hüseyin Acar', child: Text('Hüseyin Acar')),
              DropdownMenuItem(value: 'Gamze Kılıç', child: Text('Gamze Kılıç')),
              DropdownMenuItem(value: 'Mustafa Eren', child: Text('Mustafa Eren')),
              DropdownMenuItem(value: 'Burcu Tekin', child: Text('Burcu Tekin')),
              DropdownMenuItem(value: 'İsmail Yavuz', child: Text('İsmail Yavuz')),
            ],
            onChanged: (value) => _operationsOfficerController.text = value ?? '',
            validator: (value) => value == null ? 'Please select an operations officer' : null,
          ),
          const SizedBox(height: 20),
          DropdownButtonFormField<String>(
            dropdownColor: AppColors.cardColor,
            value: _postMasterController.text.isEmpty ? null : _postMasterController.text,
            decoration: const InputDecoration(
              labelText: 'Postbaşı',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(value: 'Cemal Akın', child: Text('Cemal Akın')),
              DropdownMenuItem(value: 'Fikret Güneş', child: Text('Fikret Güneş')),
              DropdownMenuItem(value: 'Kemal Aslan', child: Text('Kemal Aslan')),
              DropdownMenuItem(value: 'Orhan Korkmaz', child: Text('Orhan Korkmaz')),
              DropdownMenuItem(value: 'Selim Kurt', child: Text('Selim Kurt')),
              DropdownMenuItem(value: 'Nihat Demir', child: Text('Nihat Demir')),
              DropdownMenuItem(value: 'Tarık Çetin', child: Text('Tarık Çetin')),
              DropdownMenuItem(value: 'Vedat Özdemir', child: Text('Vedat Özdemir')),
              DropdownMenuItem(value: 'Serkan Şimşek', child: Text('Serkan Şimşek')),
              DropdownMenuItem(value: 'Uğur Canpolat', child: Text('Uğur Canpolat')),
              DropdownMenuItem(value: 'Yasin Eren', child: Text('Yasin Eren')),
              DropdownMenuItem(value: 'Ramazan Kılıç', child: Text('Ramazan Kılıç')),
              DropdownMenuItem(value: 'Erdem Yavuz', child: Text('Erdem Yavuz')),
              DropdownMenuItem(value: 'Hakan Arı', child: Text('Hakan Arı')),
              DropdownMenuItem(value: 'Volkan Tuncer', child: Text('Volkan Tuncer')),
            ],
            onChanged: (value) => _postMasterController.text = value ?? '',
            validator: (value) => value == null ? 'Please select a post master' : null,
          ),
        ],
      ),
    );
  }

  Widget _buildCargoTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          DropdownButtonFormField<String>(
            dropdownColor: AppColors.cardColor,
            value: _cargoFlagController.text.isEmpty ? null : _cargoFlagController.text,
            decoration: const InputDecoration(
              labelText: 'Kargo Flaması',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(value: 'Takılmış', child: Text('Takılmış')),
              DropdownMenuItem(value: 'Takılmamış', child: Text('Takılmamış')),
            ],
            onChanged: (value) => _cargoFlagController.text = value ?? '',
            // Optional, no validator
          ),
          const SizedBox(height: 20),
          DropdownButtonFormField<String>(
            dropdownColor: AppColors.cardColor,
            value: _loadingNumberController.text.isEmpty ? null : _loadingNumberController.text,
            decoration: const InputDecoration(labelText: 'Yükleme Numarası', border: OutlineInputBorder()),
            items: const [
              DropdownMenuItem(value: 'Yazılmış', child: Text('Yazılmış')),
              DropdownMenuItem(value: 'Yazılmamış', child: Text('Yazılmamış')),
            ],
            onChanged: (value) => _loadingNumberController.text = value ?? '',
          ),
          const SizedBox(height: 20),
          DropdownButtonFormField<String>(
            dropdownColor: AppColors.cardColor,
            value: _loadingInstructionsController.text.isEmpty ? null : _loadingInstructionsController.text,
            decoration: const InputDecoration(
              labelText: 'Yükleme Talimatları',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(value: 'Talimat 1', child: Text('Talimat 1')),
              DropdownMenuItem(value: 'Talimat 2', child: Text('Talimat 2')),
              DropdownMenuItem(value: 'Talimat 3', child: Text('Talimat 3')),
              DropdownMenuItem(value: 'Talimat 4', child: Text('Talimat 4')),
              DropdownMenuItem(value: 'Talimat 5', child: Text('Talimat 5')),
              DropdownMenuItem(value: 'Talimat 6', child: Text('Talimat 6')),
              DropdownMenuItem(value: 'Talimat 7', child: Text('Talimat 7')),
              DropdownMenuItem(value: 'Talimat 8', child: Text('Talimat 8')),
              DropdownMenuItem(value: 'Talimat 9', child: Text('Talimat 9')),
              DropdownMenuItem(value: 'Talimat 10', child: Text('Talimat 10')),
              DropdownMenuItem(value: 'Talimat 11', child: Text('Talimat 11')),
              DropdownMenuItem(value: 'Talimat 12', child: Text('Talimat 12')),
              DropdownMenuItem(value: 'Talimat 13', child: Text('Talimat 13')),
              DropdownMenuItem(value: 'Talimat 14', child: Text('Talimat 14')),
              DropdownMenuItem(value: 'Talimat 15', child: Text('Talimat 15')),
            ],
            onChanged: (value) => _loadingInstructionsController.text = value ?? '',
          ),
          const SizedBox(height: 20),
          DropdownButtonFormField<String>(
            dropdownColor: AppColors.cardColor,
            value: _loadingChangeController.text.isEmpty ? null : _loadingChangeController.text,
            decoration: const InputDecoration(labelText: 'Yükleme Değişikliği', border: OutlineInputBorder()),
            items: const [
              DropdownMenuItem(value: 'Yapıldı', child: Text('Yapıldı')),
              DropdownMenuItem(value: 'Yapılmadı', child: Text('Yapılmadı')),
            ],
            onChanged: (value) => _loadingChangeController.text = value ?? '',
          ),
          const SizedBox(height: 20),
          DropdownButtonFormField<String>(
            dropdownColor: AppColors.cardColor,
            value: _loadPlanController.text.isEmpty ? null : _loadPlanController.text,
            decoration: const InputDecoration(
                labelText: '1.Load Plan ve 2.Load Plan Sicil-imza-saat', border: OutlineInputBorder()),
            items: const [
              DropdownMenuItem(value: 'Evet', child: Text('Evet')),
              DropdownMenuItem(value: 'Hayır', child: Text('Hayır')),
            ],
            onChanged: (value) => _loadPlanController.text = value ?? '',
          ),
          const SizedBox(height: 20),
          DropdownButtonFormField<String>(
            dropdownColor: AppColors.cardColor,
            value: _loadPlanDeliveryController.text.isEmpty ? null : _loadPlanDeliveryController.text,
            decoration: const InputDecoration(
                labelText: '2.Load plan loadsheet alınmadan Teslim', border: OutlineInputBorder()),
            items: const [
              DropdownMenuItem(value: 'Evet', child: Text('Evet')),
              DropdownMenuItem(value: 'Hayır', child: Text('Hayır')),
            ],
            onChanged: (value) => _loadPlanDeliveryController.text = value ?? '',
          ),
          const SizedBox(height: 20),
          DropdownButtonFormField<String>(
            dropdownColor: AppColors.cardColor,
            value: _loadPageCompatibilityController.text.isEmpty ? null : _loadPageCompatibilityController.text,
            decoration: const InputDecoration(labelText: 'Loadsheet-Loadplan Uygunluğu', border: OutlineInputBorder()),
            items: const [
              DropdownMenuItem(value: 'Yapıldı', child: Text('Yapıldı')),
              DropdownMenuItem(value: 'Yapılmadı', child: Text('Yapılmadı')),
            ],
            onChanged: (value) => _loadPageCompatibilityController.text = value ?? '',
          ),
        ],
      ),
    );
  }

  Widget _buildNotesTab() {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: TextFormField(
            controller: _noteController,
            maxLines: 15,
            decoration: InputDecoration(
              hintStyle: const TextStyle(color: AppColors.borderColor),
              hintText: "Notunuzu yazın...",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: AppColors.searcColor.withOpacity(0.2),
              contentPadding: const EdgeInsets.all(16),
            ),
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }

  Widget _buildImagesTab() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          if (_imagePaths.isNotEmpty)
            Container(
              width: 400,
              height: 300,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  childAspectRatio: 400 / 300,
                ),
                itemCount: _imagePaths.length,
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            File(_imagePaths[index]),
                            fit: BoxFit.cover,
                            width: 400,
                            height: 300,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: IconButton(
                          icon: Icon(FeatherIcons.trash),
                          onPressed: () => _removeImage(index),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          const SizedBox(height: 30),
          SizedBox(
            width: 200,
            child: ElevatedButton(
              onPressed: _pickImage,
              style: ElevatedButton.styleFrom(
                foregroundColor: AppColors.whiteSpot,
                backgroundColor: AppColors.snackBarRed,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Görüntü Seç',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          if (_imagePaths.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Container(
                width: 400,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(20),
                  color: AppColors.searcColor.withOpacity(0.2),
                  border: Border.all(
                    color: AppColors.switchColor,
                    width: 2,
                  ),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Henüz Herhangi Bir Görüntü Seçilmedi",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    Icon(
                      FeatherIcons.cameraOff,
                      size: 60,
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
