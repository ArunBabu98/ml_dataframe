import 'package:ml_dataframe/ml_dataframe.dart';
import 'package:ml_dataframe/src/data_frame/data_frame_helpers.dart';
import 'package:ml_dataframe/src/data_frame/data_frame_impl.dart';
import 'package:ml_dataframe/src/numerical_converter/numerical_converter_impl.dart';
import 'package:ml_linalg/linalg.dart';
import 'package:quiver/iterables.dart';
import 'package:xrange/zrange.dart';

DataFrame fromMatrix(Matrix data, {
  Iterable<String> predefinedHeader = const [],
  String autoHeaderPrefix = defaultHeaderPrefix,
  Iterable<int> columns = const [],
  Iterable<int> discreteColumnIndices = const [],
  Iterable<String> discreteColumns = const [],
}) {
  final header = getHeader(
      enumerate(data.rows.first).map((indexed) => indexed.index),
      autoHeaderPrefix, null, predefinedHeader);

  final selectedData = columns?.isNotEmpty == true
      ? data.pick(columnRanges: columns.map((idx) => ZRange.singleton(idx)))
      : data;

  final selectedHeader = enumerate(header)
      .expand((indexed) => columns.contains(indexed.index)
        ? [indexed.value]
        : <String>[],
  );

  final areSeriesDiscrete = enumerate(header).map((indexedName) {
    if (discreteColumnIndices.contains(indexedName.index) ||
        discreteColumns.contains(indexedName.value)) {
      return true;
    }
    return false;
  });

  return DataFrameImpl.fromMatrix(selectedData, selectedHeader,
      NumericalConverterImpl(false), areSeriesDiscrete);
}
