import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wevoride/constant/constant.dart';
import 'package:wevoride/constant/show_toast_dialog.dart';
import 'package:wevoride/model/map/place_picker_model.dart';
import 'package:wevoride/themes/app_them_data.dart';
import 'package:wevoride/themes/text_field_widget.dart';
import 'package:wevoride/utils/dark_theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'package:wevoride/widgets/custom_scaffold.dart';

class GoogleMapSearchPlacesApi extends StatefulWidget {
  const GoogleMapSearchPlacesApi({super.key});

  @override
  GoogleMapSearchPlacesApiState createState() => GoogleMapSearchPlacesApiState();
}

class GoogleMapSearchPlacesApiState extends State<GoogleMapSearchPlacesApi> {
  final _controller = TextEditingController();
  var uuid = const Uuid();
  String? _sessionToken = '1234567890';
  List<dynamic> _placeList = [];

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      _onChanged();
    });
  }

  _onChanged() {
    if (_sessionToken == null) {
      setState(() {
        _sessionToken = uuid.v4();
      });
    }
    getSuggestion(_controller.text);
  }

  void getSuggestion(String input) async {
    try {
      String baseURL = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';
      String request = '$baseURL?input=$input&key=${Constant.mapAPIKey}&sessiontoken=$_sessionToken';
      var response = await http.get(Uri.parse(request));
      if (response.statusCode == 200) {
        setState(() {
          print(response.body);
          _placeList = json.decode(response.body)['predictions'];
        });
      } else {
        throw Exception('Failed to load predictions');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<PlaceDetailsModel?> getLatLang(String placeId) async {
    PlaceDetailsModel? placeDetailsModel;
    try {
      String baseURL = 'https://maps.googleapis.com/maps/api/place/details/json';
      String request = '$baseURL?placeid=$placeId&key=${Constant.mapAPIKey}';
      var response = await http.get(Uri.parse(request));
      // if (kDebugMode) {
      //   log(response.body);
      // }
      if (response.statusCode == 200) {
        placeDetailsModel = PlaceDetailsModel.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load predictions');
      }
    } catch (e) {
      print(e);
    }
    return placeDetailsModel;
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return CustomScaffold(
      backgroundColor: themeChange.getThem() ? AppThemeData.grey900 : AppThemeData.grey50,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppThemeData.primary300,
        centerTitle: false,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.arrow_back,
            color: themeChange.getThem() ? AppThemeData.grey900 : AppThemeData.grey50,
          ),
        ),
        title: Text(
          'Search Place',
          style: TextStyle(
            color: themeChange.getThem() ? AppThemeData.grey900 : AppThemeData.grey50,
            fontSize: 16,
            fontFamily: AppThemeData.medium,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            TextFieldWidget(
              hintText: 'Search your location here',
              controller: _controller,
              prefix: const Icon(Icons.map),
              suffix: IconButton(
                icon: const Icon(Icons.cancel),
                onPressed: () {
                  _controller.clear();
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _placeList.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () async {
                      ShowToastDialog.showLoader("Please wait");
                      await getLatLang(_placeList[index]["place_id"]).then((value) {
                        if (value != null) {
                          ShowToastDialog.closeLoader();
                          Get.back(result: value);
                        }
                      });
                    },
                    child: ListTile(
                      title: Text(
                        _placeList[index]["description"],
                        style: TextStyle(
                          fontFamily: AppThemeData.regular,
                          color: themeChange.getThem() ? AppThemeData.grey50 : AppThemeData.grey900,
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
