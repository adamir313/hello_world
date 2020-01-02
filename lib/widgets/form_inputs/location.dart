import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hello_world/Shared/global_config.dart';
import 'package:hello_world/models/location_data.dart';
import 'package:hello_world/models/product.dart';
import 'package:hello_world/widgets/helper/ensure_visible.dart';

import 'package:http/http.dart' as http;

import 'package:location/location.dart' as geoloc;
import 'package:mapbox_search/mapbox_search.dart';

class LocationInput extends StatefulWidget {
  final Function setLocation;
  final Product product;

  LocationInput(this.setLocation, this.product);

  @override
  State<StatefulWidget> createState() {
    return _LocationInputState();
  }
}

class _LocationInputState extends State<LocationInput> {
  String _staticMapUri;
  LocationData _locationData;
  final FocusNode _addressInputFocusNode = FocusNode();
  final TextEditingController _addressInputController = TextEditingController();

  @override
  void initState() {
    _addressInputFocusNode.addListener(_updateLocation);
    //we may be in product creation not edit
    if (widget.product != null) {
      _getStaticMap(widget.product.location.address, geocode: false);
    }
    super.initState();
  }

  @override
  void dispose() {
    _addressInputFocusNode.removeListener(_updateLocation);
    super.dispose();
  }

  void _getStaticMap(String address,
      {bool geocode = true, double lat, double lng}) async {
    if (address.isEmpty) {
      setState(() {
        _staticMapUri = null;
      });
      widget.setLocation(null);
      return;
    }

    if (geocode) {
      //Google API
      // final Uri uri = Uri.https(
      //     'maps.googleapis.com', '/maps/api/geocode/json', {
      //   'address': address,
      //   'key': googleMapApiKey
      // });
      //final http.Response response = await http.get(uri);
      //final decodedResponse = json.decode(response.body);
      //final formattedAddress = decodedResponse['results'][0]['formatted_address'];
      //final coords = decodedResponse['results'][0]['geometry']['location'];
      // _locationData = LocationData(
      //     address: formattedAddress,
      //     latitude: coords['lat'],
      //     longitude: coords['lng']);

      //Mapbox API
      final Uri uri = Uri.https(
          'api.mapbox.com',
          '/geocoding/v5/mapbox.places/$address.json',
          {'access_token': mapboxAccessToken});
      final http.Response response = await http.get(uri);
      final decodedResponse = json.decode(response.body);
      final formattedAddress = decodedResponse['features'][0]['place_name'];
      List<dynamic> coords =
          decodedResponse['features'][0]['geometry']['coordinates'];
      _locationData = LocationData(
          address: formattedAddress, latitude: coords[1], longitude: coords[0]);
    } else if (lat == null && lng == null) {
      _locationData = widget.product.location;
    } else {
      _locationData =
          LocationData(address: address, latitude: lat, longitude: lng);
    }
    if (mounted) {
      // Google API
      // StaticMap staticMap =
      //     StaticMap(apiKey: googleMapApiKey);
      // final Uri staticMapUri = staticMap.getStaticUriWithMarkers(
      //     latitude: _locationData.latitude,
      //     longitude: _locationData.longitude,
      //     width: 500,
      //     height: 300,
      //     mapType: 'roadmap');

      //Mapbox API
      final String staticMapUri = _getMapboxStaticUrlString(
          _locationData.latitude, _locationData.longitude);
      widget.setLocation(_locationData);

      setState(() {
        _addressInputController.text = _locationData.address;
        _staticMapUri = staticMapUri;
      });
    }
  }

  //Google API
  Future<String> _getAddress(double lat, double lng) async {
    final Uri uri = Uri.https('maps.googleapis.com', '/maps/api/geocode/json', {
      'latlng': '${lat.toString()},${lng.toString()}',
      'key': googleMapApiKey
    });
    final http.Response response = await http.get(uri);
    final decodedResponse = json.decode(response.body);
    final formattedAddress = decodedResponse['results'][0]['formatted_address'];
    return formattedAddress;
  }

  //Mapbox API
  Future<String> _getMapboxAddress(double lat, double lng) async {
    ReverseGeoCoding reverseGeoCoding = ReverseGeoCoding(
      apiKey: mapboxAccessToken,
      limit: 1,
    );
    List<MapBoxPlace> address = await reverseGeoCoding.getAddress(
      Location(lat: lat, lng: lng),
    );
    return address.first.placeName;
  }

  void _getUserLocation() async {
    final location = geoloc.Location();
    try {
      final currentLocation = await location.getLocation();
      //Google API
      //final address =
      //  await _getAddress(currentLocation.latitude, currentLocation.longitude);

      //Mapbox API
      final address = await _getMapboxAddress(
          currentLocation.latitude, currentLocation.longitude);

      _getStaticMap(address,
          geocode: false,
          lat: currentLocation.latitude,
          lng: currentLocation.longitude);
    } catch (error) {
      //location permisson error
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Could not fetch Location.'),
              content: Text('Please add an address manually.'),
              actions: <Widget>[
                FlatButton(
                  child: Text('Okay'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            );
          });
    }
  }

  void _updateLocation() {
    if (!_addressInputFocusNode.hasFocus) {
      _getStaticMap(_addressInputController.text);
    }
  }

  String _getMapboxStaticUrlString(double lat, double lng) {
    MapBoxStaticImage staticImage =
        MapBoxStaticImage(apiKey: mapboxAccessToken);
    String staticImageUrlString = staticImage.getStaticUrlWithMarker(
      center: Location(lat: lat, lng: lng),
      marker: MapBoxMarker(
          markerColor: Colors.red,
          markerLetter: 'p',
          markerSize: MarkerSize.LARGE),
      height: 300,
      width: 500,
      style: MapBoxStyle.Mapbox_Streets,
      render2x: true,
    );
    return staticImageUrlString;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        EnsureVisibleWhenFocused(
            focusNode: _addressInputFocusNode,
            child: TextFormField(
              focusNode: _addressInputFocusNode,
              controller: _addressInputController,
              validator: (String value) {
                if (_locationData == null || value.isEmpty) {
                  return 'No valid location found!';
                }
              },
              decoration: InputDecoration(labelText: 'Address'),
            )),
        SizedBox(
          height: 10.0,
        ),
        FlatButton(
          child: Text('Locate User'),
          onPressed: _getUserLocation,
        ),
        SizedBox(
          height: 10.0,
        ),
        _staticMapUri == null ? Container() : Image.network(_staticMapUri)
      ],
    );
  }
}
