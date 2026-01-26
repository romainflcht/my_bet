import 'package:esme2526/models/bet.dart';
import 'package:esme2526/views/bet_page.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import 'package:esme2526/constants/ui.dart';
import 'package:flutter/cupertino.dart';


class BetWidget extends StatefulWidget 
{
  final Bet bet;

  const BetWidget({super.key, required this.bet});

  @override
  State<BetWidget> createState() => _BetWidgetState();
}


class _BetWidgetState extends State<BetWidget> 
{
  late YoutubePlayerController controller;
  bool betIsFavorite = false;

// _ METHODS ___________________________________________________________________
  @override
  void initState() 
  {
    super.initState();
    String videoId = YoutubePlayerController.convertUrlToId(widget.bet.dataBet.videoUrl) ?? '';


    controller = YoutubePlayerController.fromVideoId(
      videoId: videoId,
      params: const YoutubePlayerParams(
        showControls: false,
        showFullscreenButton: false,
        mute: true,
        loop: true,
        origin: 'https://www.youtube-nocookie.com',
      ),
    );
  }

  @override
  void dispose() 
  {
    controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) 
  {
    return Container(
    margin: const EdgeInsets.all(10.0), 
    decoration: BoxDecoration(
      color: AppColors.ui,
      borderRadius: BorderRadius.circular(25.0),
      boxShadow: [
        BoxShadow(
          color: AppColors.accent, 
          spreadRadius: 0, 
          blurRadius: 5, 
          offset: const Offset(0, 0)
        )
      ],
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min, 
      crossAxisAlignment: CrossAxisAlignment.stretch, 
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25.0), 
            topRight: Radius.circular(25.0)
          ),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: YoutubePlayer(controller: controller),
          ),
        ),


        Padding(
          padding: const EdgeInsets.all(16.0), 
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.bet.title,
                style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: AppColors.text),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                widget.bet.description,
                style: const TextStyle(fontSize: 14.0, color: AppColors.descText),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              
              const SizedBox(height: 16), 

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF781F),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      widget.bet.odds.toStringAsFixed(2),
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Color(0xFF00B5FF), 
                      borderRadius: BorderRadius.circular(8.0)
                    ),
                    child: Text(
                      _formatDateTime(widget.bet.startTime),
                      style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.text),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: FilledButton(
                      onPressed: () 
                      {
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => BetPage(bet: widget.bet, textEditingController: TextEditingController()),
                          ),
                        ); 
                      },
                      child: const Text("Place bet"),
                    ),
                  ),
                  IconButton(
                    icon: betIsFavorite ? Icon(CupertinoIcons.heart_solid, color: AppColors.liked) : Icon(CupertinoIcons.heart),
                    onPressed: () => setState(() {
                        betIsFavorite = !betIsFavorite; 
                      }), 
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

  String _formatDateTime(DateTime dateTime) 
  {
    return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
