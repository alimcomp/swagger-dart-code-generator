import 'dart:convert';

import 'package:code_builder/code_builder.dart';
import 'package:swagger_dart_code_generator/src/code_generators/swagger_additions_generator.dart';
import 'package:swagger_dart_code_generator/src/code_generators/swagger_enums_generator.dart';
import 'package:swagger_dart_code_generator/src/code_generators/swagger_models_generator.dart';
import 'package:swagger_dart_code_generator/src/code_generators/swagger_requests_generator.dart';
import 'package:swagger_dart_code_generator/src/code_generators/v2/swagger_enums_generator_v2.dart';
import 'package:swagger_dart_code_generator/src/code_generators/v2/swagger_models_generator_v2.dart';
import 'package:swagger_dart_code_generator/src/code_generators/v3/swagger_enums_generator_v3.dart';
import 'package:swagger_dart_code_generator/src/code_generators/v3/swagger_models_generator_v3.dart';
import 'package:swagger_dart_code_generator/src/models/generator_options.dart';

class SwaggerCodeGenerator {
  final Map<int, SwaggerEnumsGenerator> _enumsMap =
      <int, SwaggerEnumsGenerator>{
    2: SwaggerEnumsGeneratorV2(),
    3: SwaggerEnumsGeneratorV3()
  };

  final Map<int, SwaggerModelsGenerator> _modelsMap =
      <int, SwaggerModelsGenerator>{
    2: SwaggerModelsGeneratorV2(),
    3: SwaggerModelsGeneratorV3()
  };

  int _getApiVersion(String dartCode) {
    final dynamic map = jsonDecode(dartCode);

    final openApi = map['openapi'] as String?;
    return openApi != null ? 3 : 2;
  }

  String generateIndexes(
          String dartCode, Map<String, List<String>> buildExtensions) =>
      _getSwaggerAdditionsGenerator(dartCode).generateIndexes(buildExtensions);

  String generateImportsContent(
    String dartCode,
    String swaggerFileName,
    bool hasModels,
    bool buildOnlyModels,
    bool hasEnums,
    bool separateModels,
  ) =>
      _getSwaggerAdditionsGenerator(dartCode).generateImportsContent(
          swaggerFileName,
          hasModels,
          buildOnlyModels,
          hasEnums,
          separateModels);

  Map<String, dynamic> generateResponses(
          String dartCode, String fileName, GeneratorOptions options) =>
      _getSwaggerModelsGenerator(dartCode)
          .generateResponses(dartCode, fileName, options);

  Map<String, dynamic> generateRequestBodies(
          String dartCode, String fileName, GeneratorOptions options) =>
      _getSwaggerModelsGenerator(dartCode)
          .generateRequestBodies(dartCode, fileName, options);

  Map<String, String> generateEnums(String dartCode, String fileName) =>
      _getSwaggerEnumsGenerator(dartCode).generate(dartCode, fileName);
  Map<String, dynamic> generateModels(
          String dartCode, String fileName, GeneratorOptions options) =>
      _getSwaggerModelsGenerator(dartCode)
          .generate(dartCode, fileName, options);

  Map<String, Class> generateRequests(String dartCode, String className,
          String fileName, GeneratorOptions options) =>
      _getSwaggerRequestsGenerator(dartCode).generate(
        code: dartCode,
        className: className,
        fileName: fileName,
        options: options,
      );

  String generateDateToJson(String dartCode) =>
      _getSwaggerAdditionsGenerator(dartCode).generateDateToJson();

  SwaggerAdditionsGenerator _getSwaggerAdditionsGenerator(String dartCode) =>
      SwaggerAdditionsGenerator();

  SwaggerEnumsGenerator _getSwaggerEnumsGenerator(String dartCode) =>
      _enumsMap[_getApiVersion(dartCode)]!;

  SwaggerModelsGenerator _getSwaggerModelsGenerator(String dartCode) =>
      _modelsMap[_getApiVersion(dartCode)]!;

  SwaggerRequestsGenerator _getSwaggerRequestsGenerator(String dartCode) =>
      SwaggerRequestsGenerator();
}
