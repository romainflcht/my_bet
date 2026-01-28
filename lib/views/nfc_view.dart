import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/nfc_manager_android.dart';


class NFCReaderScreen extends StatefulWidget 
{
  const NFCReaderScreen({super.key});

  @override
  State<NFCReaderScreen> createState() => _NFCReaderScreenState();
}


class _NFCReaderScreenState extends State<NFCReaderScreen> 
{
  String nfcData = "Tap an NFC tag";
  Future<void> startNFC() async {
    NfcAvailability  isAvailable = await NfcManager.instance.checkAvailability();

    if (isAvailable != NfcAvailability.enabled) 
    {
      setState(() {
        nfcData = "NFC is not available on this device";
      });

      return;
    }
    NfcManager.instance.startSession(
      pollingOptions: {
      NfcPollingOption.iso14443, 
      NfcPollingOption.iso15693, 
      NfcPollingOption.iso18092
    }, 
    
    onDiscovered: (NfcTag tag) async 
    {
      NfcAAndroid? nfc = NfcAAndroid.from(tag);

      if (nfc == null) 
      {
        setState(() {
          nfcData = "NFC tag not in the correct format.";
        });
      
        await NfcManager.instance.stopSession();        
        return; 
      }

      List<int> idBytes = nfc.tag.id;


      setState(() {
        nfcData = idBytes.toString();
      });
      await NfcManager.instance.stopSession();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("NFC Reader")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(nfcData, style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: startNFC,
              child: Text("Scan NFC Tag"),
            ),
          ],
        ),
      ),
    );
  }
}