import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:open_filex/open_filex.dart';
import 'package:share_plus/share_plus.dart';

class FormScreen extends StatefulWidget {
  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _jobController = TextEditingController();
  final TextEditingController _nicController = TextEditingController();
  final TextEditingController _whatsappController = TextEditingController();

  late File _pdfFile;

  Future<void> _generateAndSavePdf() async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Name: ${_nameController.text}', style: pw.TextStyle(fontSize: 18)),
              pw.Text('Age: ${_ageController.text}', style: pw.TextStyle(fontSize: 18)),
              pw.Text('Job: ${_jobController.text}', style: pw.TextStyle(fontSize: 18)),
              pw.Text('NIC: ${_nicController.text}', style: pw.TextStyle(fontSize: 18)),
              pw.Text('WhatsApp: ${_whatsappController.text}', style: pw.TextStyle(fontSize: 18)),
            ],
          );
        },
      ),
    );

    final output = await getTemporaryDirectory();
    _pdfFile = File("${output.path}/form_data.pdf");
    await _pdfFile.writeAsBytes(await pdf.save());

    // Open the PDF
    OpenFilex.open(_pdfFile.path);
  }

  Future<void> _sendPdfToWhatsapp() async {
    if (_pdfFile.existsSync()) {
      await Share.shareXFiles([XFile(_pdfFile.path)],
          text: 'Please find the attached PDF.');
    } else {
      print("PDF file doesn't exist!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Form')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _ageController,
                decoration: InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your age';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _jobController,
                decoration: InputDecoration(labelText: 'Job'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your job';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _nicController,
                decoration: InputDecoration(labelText: 'NIC'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your NIC';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _whatsappController,
                decoration: InputDecoration(labelText: 'WhatsApp Number'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your WhatsApp number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _generateAndSavePdf();
                  }
                },
                child: Text('Submit'),
              ),
              ElevatedButton(
                onPressed: _sendPdfToWhatsapp,
                child: Text('Send to WhatsApp'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
