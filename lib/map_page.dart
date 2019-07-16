import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_careem_demo/resources.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MapBody();
  }
}

class MapBody extends StatefulWidget {
  @override
  _MapBodyState createState() => _MapBodyState();
}

class _MapBodyState extends State<MapBody> with SingleTickerProviderStateMixin {
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController _googleMapController;
  MapType _currentMapType = MapType.normal;
  final _initialLocation = LatLng(31.2281489, 29.9535593);
  LatLng currentLocation; // the final location value
  Marker currentPositionMarker;
  static const MARKER_ID = "markerID";
  Set<Marker> markers;
  var location = new Location();


  @override
  void initState() {
    super.initState();
    _initCurrentLocation();
    markers = new Set();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Center(child: Text('Dummy User Data')),
      ),
      body: SafeArea(
        child: Stack(children: <Widget>[
          Container(
            width: double.infinity,
            height: double.infinity,
            child: GoogleMap(
              onCameraMove: (newPosition) {
                drawMarker(LatLng(
                    newPosition.target.latitude, newPosition.target.longitude));
                currentLocation = LatLng(
                    newPosition.target.latitude, newPosition.target.longitude);
              },
              markers: markers,
              rotateGesturesEnabled: true,
              compassEnabled: false,
              mapType: _currentMapType,
              onMapCreated: _onMapCreated,
              myLocationEnabled: false,
              initialCameraPosition: CameraPosition(
                bearing: 270.0,
                target: _initialLocation,
                tilt: 30.0,
                zoom: 17.0,
              ),
            ),
          ),
          MapTopHeader(),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Align(
                  alignment: Alignment.centerRight,
                  child: Card(
                    child: SizedBox(
                      height: 50,
                      width: 50,
                      child: Container(
                        child: Icon(
                          Icons.explore,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    print('here');
                    _goToMyLocation();
                  },
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Card(
                      child: SizedBox(
                        height: 50,
                        width: 50,
                        child: Container(
                          child: Icon(
                            Icons.gps_fixed,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                VehicleTypeMenu(),
                PickUpConfirm(),
                SizedBox(
                  height: Dimensions.interItemSpacingRegular,
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }


  _goToMyLocation() async{
    var currentPosition = await location.getLocation();
    if(currentPosition != null){
      _googleMapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
              bearing: 192.8334901395799,
              target: LatLng(currentPosition.latitude, currentPosition.longitude),
              tilt: 59.440717697143555,
              zoom: 19.151926040649414
          )
      ));
      drawMarker(LatLng(currentPosition.latitude, currentPosition.longitude));
    }
  }

  _initCurrentLocation() async{
//    LocationData currentLocationData;
//    String error;

    var serviceEnabled = await location.serviceEnabled();
    if(!serviceEnabled){
      await location.requestService();
    }
//
//    try {
//      currentLocationData = await location.getLocation();
//    } on PlatformException catch (e) {
//      if (e.code == 'PERMISSION_DENIED') {
//        error = 'Permission denied';
//      }
//      currentLocationData = null;
//    }


    var currentPosition = await location.getLocation();
    if(currentPosition != null){
      drawMarker(LatLng(currentPosition.latitude, currentPosition.longitude));
      currentLocation = LatLng(currentPosition.latitude, currentPosition.longitude); // init currentLocation
    }
  }

  void _onMapCreated(GoogleMapController controller) async {
    _controller.complete(controller);
    _googleMapController = await _controller.future;
    setState(() {});
  }

  drawMarker(LatLng currentPosition) {
    setState(() {
      markers = new Set()
        ..add(Marker(
          markerId: MarkerId(MARKER_ID),
          draggable: true,
          position: LatLng(currentPosition.latitude, currentPosition.longitude),
          icon: BitmapDescriptor.defaultMarker,
        ));

      print(
          "current Marker: lat: ${currentPosition.latitude} , long: ${currentPosition.longitude}");
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class PickUpConfirm extends StatelessWidget {
  const PickUpConfirm({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: MaterialButton(
              height: 60,
              onPressed: () {},
              child: Text(
                Strings.confirmPickUp,
                style: Theme.of(context).textTheme.display1,
              ),
              color: Colors.green,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0))),
            ),
          ),
          SizedBox(
            width: Dimensions.interItemSpacingRegular,
          ),
          Card(
            margin: EdgeInsets.all(0.0),
            child: SizedBox(
              height: 60,
              width: 60,
              child: Container(
                child: Icon(
                  Icons.insert_invitation,
                  color: Colors.green,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class VehicleTypeMenu extends StatelessWidget {
  const VehicleTypeMenu({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return ListView.builder(
                itemCount: 6,
                itemBuilder: (_, index) {
                  return VehicleTypeContainer(isSelected: false);
                },
              );
            });
      },
      child: Card(
        child: VehicleTypeContainer(isSelected: true),
      ),
    );
  }
}

class VehicleTypeContainer extends StatelessWidget {
  final bool isSelected;

  const VehicleTypeContainer({
    Key key,
    this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 40,
            height: 30,
            child: Container(
              color: Colors.greenAccent,
            ),
          ),
          SizedBox(
            width: Dimensions.interItemSpacingRegular,
          ),
          Expanded(
            child: Text(
              Strings.go,
              style: Theme.of(context).textTheme.title,
            ),
          ),
          Text(
            Strings.dummyDuration,
            style: Theme.of(context).textTheme.body1,
          ),
          isSelected
              ? Icon(
                  Icons.arrow_drop_down,
                  color: Colors.grey,
                )
              : Container()
        ],
      ),
    );
  }
}

class MapTopHeader extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        MapAppBar(),
        LocationCard(),
      ],
    );
  }
}

class MapAppBar extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      title: Text(
        Strings.selectPickUpLocation,
        style: Theme.of(context).textTheme.title,
      ),
      elevation: 0.0,
      leading: InkWell(
        onTap: () {
          Scaffold.of(context).openDrawer();
        },
        child: Icon(Icons.menu),
      ),
    );
  }
}

class LocationCard extends StatelessWidget {
  const LocationCard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            new HollowCircle(),
            SizedBox(
              width: Dimensions.interItemSpacingRegular,
            ),
            new AddressDetails(),
            SizedBox(
              width: Dimensions.interItemSpacingRegular,
            ),
            new MarkFavourite(),
          ],
        ),
      ),
    );
  }
}

class MarkFavourite extends StatefulWidget {
  const MarkFavourite({
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MarkFavouriteState();
  }
}

class _MarkFavouriteState extends State<MarkFavourite> {
  bool isFavourite = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isFavourite = !isFavourite;
        });
      },
      child: Icon(
        isFavourite ? Icons.favorite : Icons.favorite_border,
        color: Colors.green,
      ),
    );
  }
}

class AddressDetails extends StatelessWidget {
  const AddressDetails({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            Strings.dummyLocation,
            style: Theme.of(context).textTheme.body2,
            textAlign: TextAlign.start,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            Strings.dummyLocationDescription,
            style: Theme.of(context).textTheme.body1,
            textAlign: TextAlign.start,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class HollowCircle extends StatelessWidget {
  const HollowCircle({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: Colors.white,
          border: Border.all(color: Colors.green, width: 3)),
    );
  }
}
