import 'package:student_list/database/models.dart';

import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

class PdfAndPrinting {
  Future<void> createPdf([List<Student>? data]) async {
    if (data != null) {
      final doc = pw.Document();
      doc.addPage(
        pw.MultiPage(
          margin: const pw.EdgeInsets.all(10),
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return [
              pw.ListView.builder(
                itemBuilder: (context, index) {
                  return pw.Container(
                    padding: const pw.EdgeInsets.all(6),
                    margin: const pw.EdgeInsets.all(6),
                    decoration: pw.BoxDecoration(
                      color: const PdfColor.fromInt(0xFFEDE7F6),
                      borderRadius: pw.BorderRadius.circular(16),
                    ),
                    child: data.map(
                      (student) {
                        return pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Row(
                              children: [
                                pw.Text(
                                  "S.N. ${index + 1}",
                                  style: pw.TextStyle(
                                    color: const PdfColor.fromInt(0xFF000000),
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                                ),
                                pw.Text(
                                  "  ${student.name}",
                                  style: pw.TextStyle(
                                    color: const PdfColor.fromInt(0xFF448AFF),
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            pw.Text(
                              "Class. ${student.className}",
                              style: pw.TextStyle(
                                color: const PdfColor.fromInt(0xFF000000),
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                            pw.Text(
                              "Roll No. ${student.rollNumber}",
                              style: pw.TextStyle(
                                color: const PdfColor.fromInt(0xFF000000),
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ],
                        );
                      },
                    ).elementAt(index),
                  );
                },
                itemCount: data.length,
              )
            ];
          },
        ),
      );
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => doc.save(),
      );
    }
  }
}
