import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

const API_KEY = "1702083a-d7aa-4084-8692-a56128db7386";
const BASE_URL = "https://davy-api-dsesgdq4oa-lz.a.run.app";

//endpoints
//start_conversation
//send_message/${conversationId}

typedef CharCallback = void Function(String character);

typedef IsThinkingCallback = void Function(bool value);

class StartConversationReturn {
  final String responseBody;
  final String? conversationId;

  StartConversationReturn(this.responseBody, this.conversationId);
}

class StreamControllerEvent {
  StreamController<String> dataStreamController = StreamController<String>();
  // constructor
  final Map<String, String> headers = {
    'content-type': 'application/json',
    'accept': 'text/event-stream',
    'access_token': API_KEY,
  };

  Future<StartConversationReturn> _startStreaming(
      String endpointMethod, IsThinkingCallback isThinkingCallback) async {
    final url = Uri.parse('$BASE_URL/$endpointMethod?as_text_stream=true');

    var requestData = {"language": "english"};

    isThinkingCallback(true);

    final response =
        await http.post(url, headers: headers, body: jsonEncode(requestData));
    if (response.statusCode == 200) {
      final responseBody = response.body;
      final conversationId = response.headers["x-conversation-id"];
      StartConversationReturn initialResponse =
          StartConversationReturn(responseBody, conversationId);
      isThinkingCallback(false);
      return initialResponse;
    } else {
      StartConversationReturn initialResponse =
          StartConversationReturn("error", "error");
      isThinkingCallback(false);
      return initialResponse;
    }
  }

  Future _sendMessage(String endpointMethod, String message,
      CharCallback charCallback, IsThinkingCallback isThinkingCallback) async {
    final client = http.Client();

    final url = Uri.parse('$BASE_URL/$endpointMethod?as_text_stream=true');
    var requestData = {
      "message": message,
      "collection_name": "demo_segments",
      "entities": ["3311"],
    };

    isThinkingCallback(true);

    try {
      final response = await client.post(url,
          headers: headers, body: jsonEncode(requestData));

      if (response.statusCode == 200) {
        final bodyResponse = await processResponseBody(response.bodyBytes);
        isThinkingCallback(false);
        charCallback(bodyResponse);
      } else {
        isThinkingCallback(false);
        print("Request failed with status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      isThinkingCallback(false);
      client.close();
    }
  }

  startStreaming(
    String endpointMethod,
    IsThinkingCallback isThinkingCallback,
  ) async {
    return await _startStreaming(endpointMethod, isThinkingCallback);
  }

  sendMessage(
    String endpointMethod,
    String message,
    void Function(String) callback,
    IsThinkingCallback isThinkingCallback,
  ) async {
    return await _sendMessage(
        endpointMethod, message, callback, isThinkingCallback);
  }

  void disposeStream() {
    dataStreamController.close();
  }
}

Future<String> processResponseBody(List<int> bodyBytes) async {
  final streamController = StreamController<List<int>>();
  final stream = streamController.stream
      .transform(utf8.decoder); // Use the appropriate decoder for your data
  final completer = Completer<String>();
  final StringBuffer accumulatedData = StringBuffer();

  stream.listen((data) {
    // Process the data as it arrives
    accumulatedData.write(data); // Accumulate the data
  }, onDone: () {
    completer.complete(
        accumulatedData.toString()); // Complete with the accumulated data
  }, onError: (error) {
    completer.completeError(error);
  });

  for (var chunkSize = 0; chunkSize < bodyBytes.length; chunkSize += 1024) {
    final end = (chunkSize + 1024 < bodyBytes.length)
        ? chunkSize + 1024
        : bodyBytes.length;
    final chunk = bodyBytes.sublist(chunkSize, end);
    streamController.add(chunk);
  }

  streamController.close(); // Close the stream when done processing
  return completer.future;
}
