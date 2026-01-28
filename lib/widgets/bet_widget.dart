import 'package:esme2526/models/bet.dart';
import 'package:esme2526/views/place_bet_view.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import 'package:esme2526/constants/ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:esme2526/utils/utils.dart';


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
      autoPlay: true,
      videoId: videoId,
      params: const YoutubePlayerParams(

        showControls: false,
        showFullscreenButton: false,
        enableCaption: false,
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
    margin: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0), 
    decoration: BoxDecoration(
      color: AppColors.ui,
      borderRadius: BorderRadius.circular(25.0),
      boxShadow: [
        BoxShadow(
          color: AppColors.accent, 
          spreadRadius: -1, 
          blurRadius: 4, 
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
            aspectRatio: 21 / 9,
            child: Stack(fit: StackFit.expand, children: [
              YoutubePlayer(controller: controller), 
              Container(
                color: Colors.transparent,
                width: double.infinity,
                height: double.infinity,
              ),
            ]),
          ),
        ),


        Flexible(
          child: Padding(
            padding: const EdgeInsets.all(16.0), 
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '(${widget.bet.id}) ${widget.bet.title}',
                  style: const TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, color: AppColors.text),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  widget.bet.description,
                  style: const TextStyle(fontSize: 11.0, color: AppColors.descText),
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
                        formatDateTime(widget.bet.startTime),
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
        ),
        ],
      ),
    );
  }
}
