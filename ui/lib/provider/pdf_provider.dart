import 'package:codas_method/helpers/table_helper.dart';
import 'package:codas_method/model/model_results.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:universal_html/html.dart' as html;

class PDFProvider {
  var _helper = TableHelper();
  createPDF(ModelResults _data) async {
    final pdf = pw.Document();
    var _normalizedMatrixArray = _helper.getMatrixArray(
        _data.results.normalizedMatrix, _helper.getAlternatives(_data));
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Column(
              children: [
                pw.Text("Hello World"),
                pw.Table.fromTextArray(data: _normalizedMatrixArray)
              ],
            ),
          );
        },
      ),
    );
    final bytes = await pdf.save();
    final blob = html.Blob([bytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = 'some_name.pdf';
    html.document.body.children.add(anchor);
    anchor.click();
    html.document.body.children.remove(anchor);
    html.Url.revokeObjectUrl(url);
  }
}
