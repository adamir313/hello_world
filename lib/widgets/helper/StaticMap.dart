
class StaticMap {
  final String apiKey;

  StaticMap({this.apiKey});

  Uri getStaticUriWithMarkers({latitude, longitude, width, height, mapType}) {
    return Uri(
        scheme: 'https',
        host: 'maps.googleapis.com',
        path: '/maps/api/staticmap',
        queryParameters: {
          'center': '$latitude,$longitude',
          'size': '${width}x$height',
          //'zoom': '4',
          'markers': '$latitude,$longitude',
          'maptype': '$mapType',
          'key': '$apiKey'
        });
  }
}
