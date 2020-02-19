import 'dart:io';
import 'dart:convert';
import 'dart:async';

List<String> items = List<String>();
List<String> tempItems = List<String>();
List<String> devices = List<String>();
List<String> programs = List<String>();
Section section;


/// Sends the tcp packet to the server and gets the response that has the data
Future<String> apiRequest(String url, Map jsonMap) async {
  HttpClient httpClient = new HttpClient();
  HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
  request.headers.set('content-type', 'application/json');
  request.add(utf8.encode(json.encode(jsonMap)));
  HttpClientResponse response = await request.close();
  String reply = await response.transform(utf8.decoder).join();
  httpClient.close();
  return reply;
}

enum Section
{
  Microcenter,
  AutoStart,
  Programs,
}