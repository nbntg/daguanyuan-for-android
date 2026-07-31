import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

class MathContent extends StatelessWidget {
  const MathContent(
    this.source, {
    super.key,
    this.baseStyle,
    this.scale = 1,
    this.selectable = true,
  });

  final String source;
  final TextStyle? baseStyle;
  final double scale;
  final bool selectable;

  @override
  Widget build(BuildContext context) {
    final style = (baseStyle ?? Theme.of(context).textTheme.bodyLarge!)
        .copyWith(fontSize: (baseStyle?.fontSize ?? 18) * scale, height: 1.75);
    final pieces = _splitMath(source);
    final content = Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      runSpacing: 8,
      children: [
        for (final piece in pieces)
          if (piece.math)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
              child: Math.tex(
                piece.text.trim(),
                textStyle: style,
                mathStyle: piece.display ? MathStyle.display : MathStyle.text,
                onErrorFallback: (error) => selectable
                    ? SelectableText(
                        piece.text,
                        style: style.copyWith(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      )
                    : Text(
                        piece.text,
                        style: style.copyWith(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
              ),
            )
          else
            selectable
                ? SelectableText(
                    _stripSimpleMarkdown(piece.text),
                    style: style,
                  )
                : Text(
                    _stripSimpleMarkdown(piece.text),
                    style: style,
                  ),
      ],
    );
    return selectable ? SelectionArea(child: content) : content;
  }
}

class _Piece {
  const _Piece(this.text, {required this.math, this.display = false});
  final String text;
  final bool math;
  final bool display;
}

List<_Piece> _splitMath(String source) {
  final result = <_Piece>[];
  final pattern = RegExp(
    r'(\$\$[\s\S]*?\$\$|\\\[[\s\S]*?\\\]|\\\([\s\S]*?\\\)|(?<!\\)\$(?!\$)[\s\S]*?(?<!\\)\$)',
  );
  var cursor = 0;
  for (final match in pattern.allMatches(source)) {
    if (match.start > cursor) {
      result.add(_Piece(source.substring(cursor, match.start), math: false));
    }
    final raw = match.group(0)!;
    final display = raw.startsWith(r'$$') || raw.startsWith(r'\[');
    final body = raw.startsWith(r'$$')
        ? raw.substring(2, raw.length - 2)
        : raw.startsWith(r'\[') || raw.startsWith(r'\(')
            ? raw.substring(2, raw.length - 2)
            : raw.substring(1, raw.length - 1);
    result.add(_Piece(body, math: true, display: display));
    cursor = match.end;
  }
  if (cursor < source.length) {
    result.add(_Piece(source.substring(cursor), math: false));
  }
  return result.isEmpty ? [_Piece(source, math: false)] : result;
}

String _stripSimpleMarkdown(String value) => value
    .replaceAll(RegExp(r'!\[[^\]]*\]\([^)]+\)'), '〔题图未包含在当前离线数据中〕')
    .replaceAll(RegExp(r'\*\*(.*?)\*\*'), r'$1')
    .replaceAll(RegExp(r'__(.*?)__'), r'$1')
    .replaceAll(RegExp(r'`([^`]*)`'), r'$1');
