import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';
import 'package:atomberg_fan_controller/data/services/api_service.dart';
import 'package:atomberg_fan_controller/data/models/device_model.dart';

@GenerateMocks([Dio])
import 'api_service_test.mocks.dart';

void main() {
  late ApiService apiService;
  late MockDio mockDio;
  
  setUp(() {
    mockDio = MockDio();
    apiService = ApiService(mockDio);
  });
  
  group('ApiService', () {
    group('fetchDevices', () {
      test('should return list of devices when API call is successful', () async {
        // Arrange
        final mockResponse = Response(
          requestOptions: RequestOptions(path: ''),
          data: {
            'devices': [
              {
                'id': '1',
                'name': 'Bedroom Fan',
                'type': 'fan',
                'isOnline': true,
                'isPowerOn': true,
                'speed': 3,
                'isBreezeMode': false,
                'isLightOn': true,
              }
            ]
          },
          statusCode: 200,
        );
        
        when(mockDio.get(any)).thenAnswer((_) async => mockResponse);
        
        // Act
        final result = await apiService.fetchDevices();
        
        // Assert
        expect(result, isA<List<DeviceModel>>());
        expect(result.length, 1);
        expect(result.first.name, 'Bedroom Fan');
      });
      
      test('should throw exception when API call fails', () async {
        // Arrange
        when(mockDio.get(any)).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: ''),
            type: DioExceptionType.connectionError,
          ),
        );
        
        // Act & Assert
        expect(() => apiService.fetchDevices(), throwsException);
      });
    });
    
    group('controlPower', () {
      test('should return success response when control is successful', () async {
        // Arrange
        final mockResponse = Response(
          requestOptions: RequestOptions(path: ''),
          data: {'success': true, 'message': 'Power toggled'},
          statusCode: 200,
        );
        
        when(mockDio.post(any, data: anyNamed('data')))
            .thenAnswer((_) async => mockResponse);
        
        // Act
        final result = await apiService.controlPower('device1', true);
        
        // Assert
        expect(result.success, true);
      });
    });
  });
}