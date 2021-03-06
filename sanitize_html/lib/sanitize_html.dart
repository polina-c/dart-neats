// Copyright 2019 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

library sanitize_html;

import 'src/sane_html_validator.dart' show SaneHtmlValidator;

/// Sanitize [htmlString] to prevent XSS exploits and limit interference with
/// other markup on the page.
///
/// This function uses the HTML5 parser to build-up an in-memory DOM tree and
/// filter elements and attributes, in-line with [rules employed by Github][1]
/// when sanitizing GFM (Github Flavored Markdown).
///
/// This removes all inline Javascript, CSS, `<form>`, and other elements that
/// could be used for XSS. This sanitizer is more strict than necessary to
/// guard against XSS as this sanitizer also attempts to prevent the sanitized
/// HTML from interfering with the page it is injected into.
///
/// For example, while it is possible to allow many CSS properties, this
/// sanitizer does not allow any CSS. This creates a sanitizer that is easy to
/// validate and is usually fine when sanitizing HTML from rendered markdown.
/// The `allowElementId` and `allowClassName` options can be used to allow
/// specific element ids and class names through, otherwise `id` and `class`
/// attributes will be removed.
///
/// **Example**
/// ```dart
/// import 'package:sanitize_html/sanitize_html.dart' show sanitizeHtml;
///
/// void main() {
///   print(sanitizeHtml('<a href="javascript:alert();">evil link</a>'));
///   // Prints: <a>evil link</a>
///   // Which is a lot less evil :)
/// }
/// ```
///
/// [1]: https://github.com/jch/html-pipeline/blob/master/lib/html/pipeline/sanitization_filter.rb
String sanitizeHtml(
  String htmlString, {
  bool Function(String) allowElementId,
  bool Function(String) allowClassName,
}) {
  return SaneHtmlValidator(
    allowElementId: allowElementId,
    allowClassName: allowClassName,
  ).sanitize(htmlString);
}
