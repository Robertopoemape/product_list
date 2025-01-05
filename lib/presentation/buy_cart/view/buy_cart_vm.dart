import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:image_picker/image_picker.dart';
import 'package:product_list/presentation/buy_cart/widgets/widgets.dart';
import 'package:product_list/presentation/product/widgets/widgets.dart';
import 'package:image/image.dart' as img;
import 'package:http/http.dart' as http;

class BuyCartViewModel extends ChangeNotifier {
  BuyCartViewModel({required this.total});

  String? location;
  bool isLoading = false;
  File? _image;
  File? get image => _image;
  double? total;

  String? _paymentMethod;
  String? get paymentMethod => _paymentMethod;
  set paymentMethod(value) {
    _paymentMethod = value;
    notifyListeners();
  }

  String? _userName;
  String? get userName => _userName;
  set userName(value) {
    _userName = value;
    notifyListeners();
  }

  String? _userPhone;
  String? get userPhone => _userPhone;
  set userPhone(value) {
    _userPhone = value;
    notifyListeners();
  }

  double? _lat;
  double? get lat => _lat;
  set lat(value) {
    _lat = value;
    notifyListeners();
  }

  double? _lng;

  double? get lng => _lng;
  set lng(value) {
    _lng = value;
    notifyListeners();
  }

  Future<void> getLocation() async {
    isLoading = true;
    notifyListeners();

    try {
      bool serviceEnabled;
      LocationPermission permission;

      // Verifica si el servicio de ubicación está habilitado
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Los servicios de ubicación están desactivados.');
      }

      // Verifica permisos de ubicación
      permission = await Geolocator.checkPermission();

      // Si el permiso está denegado, solicitamos el permiso
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Permiso de ubicación denegado.');
        }
      }

      // Si el permiso está denegado permanentemente
      if (permission == LocationPermission.deniedForever) {
        throw Exception(
            'Los permisos de ubicación están permanentemente denegados.');
      }

      // Obteniene la posición actual
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      //Obtiene la dirección usando las coordenadas obtenidas
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      lat = position.latitude;
      lng = position.longitude;

      Placemark place = placemarks.first;

      location = '${place.street}, ${place.locality}, ${place.country}';
      log('Dirección actual: $location');
    } catch (e) {
      log('Error al obtener la ubicación: $e');
      location = 'Error al obtener la ubicación'; // En caso de error
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Método para capturar la foto
  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();

    // Capturar la imagen usando la cámara
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);

      // Redimensionar la imagen si es demasiado grande
      int maxSizeInBytes = 1 * 1024 * 1024; // 1 MB en bytes

      // Comprobar el tamaño del archivo
      if (await imageFile.length() > maxSizeInBytes) {
        // Si el archivo es mayor que 1 MB, reducimos la calidad de la imagen
        img.Image image = img.decodeImage(await imageFile.readAsBytes())!;

        // Redimensionar la imagen para que se ajuste al tamaño máximo de 1MB
        img.Image resizedImage = img.copyResize(image, width: 800);

        // Guardar la imagen redimensionada
        final resizedImageBytes =
            Uint8List.fromList(img.encodeJpg(resizedImage, quality: 85));

        // Guardamos el archivo redimensionado
        _image = await imageFile.writeAsBytes(resizedImageBytes);

        notifyListeners();
      } else {
        // Si la imagen ya es menor o igual a 1MB, la guardamos tal cual
        _image = imageFile;
        notifyListeners();
      }
    }
  }

  Future<bool> createOrder() async {
    final url = Uri.parse('https://shop-api-roan.vercel.app/order');

    final body = json.encode({
      "products": [
        {"id": "60b8c0c5f1b2c34f441e57c5", "amount": total?.toInt()}
      ],
      "paymentMethod": paymentMethod,
      "userName": userName,
      "userPhone": userPhone,
      "userAddress": location,
      "userLat": lat,
      "userLng": lng,
      "userPhoto": _image?.path ?? '',
    });

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: body,
      );

      log('Estado de la respuesta: ${response.statusCode}');
      log('Cuerpo de la respuesta: ${response.body}');

      if (response.statusCode == 201) {
        print('Compra realizada con éxito: ${response.body}');
        return true;
      } else {
        print('Error al realizar la compra: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error al hacer la solicitud: $e');
      return false;
    }
  }
}
