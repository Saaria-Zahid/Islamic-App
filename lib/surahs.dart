import 'package:al_quran/favorite.dart';
import 'package:al_quran/theme_styling/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:quran/quran.dart' as quran;
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';


class FavSurahClass {
  List<int> favSurah = [1, 18];

  void addFavSurah(int surahIndex) {
    favSurah.add(surahIndex);
    print('Added Surah $surahIndex to Favorites');
  }

  void removeFavSurah(int surahIndex) {
    favSurah.remove(surahIndex);
  }

  List<int> getFavSurah() {
    return favSurah;
  }
}

class Quran extends StatefulWidget {
  const Quran({super.key});

  @override
  State<Quran> createState() => _QuranState();
}

class _QuranState extends State<Quran> {
  final FavSurahClass favSurahClass = FavSurahClass();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quran'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      FavoritesPage(favSurahClass: favSurahClass),
                ),
              );
            },
          ),
        ],
      ),
      body: surahList(),
    );
  }

  Widget surahList() {
    return ListView.builder(
      itemCount: quran.totalSurahCount,
      itemBuilder: (context, index) {
        int surahIndex = index + 1;

        return Card(
          color: Theme.of(context).colorScheme.onSurface,
          elevation: 4,
          shape: const BeveledRectangleBorder(),
          child: ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SurahRead(surahIndex)),
              );
            },
            leading: CircleAvatar(
              radius: 20,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Text('$surahIndex'),
            ),
            title: Text(
              quran.getSurahNameArabic(surahIndex),
              style: surahText(context),
            ),
            subtitle: Text(
              quran.getSurahName(surahIndex),
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
            trailing:
          //      trailing: Column(children: [
          //    quran.getPlaceOfRevelation(index+1) == 'Makkah'
          // ? Image.asset('assets/images/makkah.png', width: 30, height: 30,)
          // : Image.asset('assets/images/madina.png', width: 30, height: 30,),
          //  Text('Ayahs ${quran.getVerseCount(index+1)}',),
          // ],)
            
             GestureDetector(
              onTap: () {
                setState(() {
                  if (favSurahClass.favSurah.contains(surahIndex)) {
                    favSurahClass.removeFavSurah(surahIndex);
                  } else {
                    favSurahClass.addFavSurah(surahIndex);
                  }
                });
              },
              child: Icon(
                favSurahClass.favSurah.contains(surahIndex)
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: favSurahClass.favSurah.contains(surahIndex)
                    ? Colors.red
                    : Colors.grey.shade400,
              ),
            ),
          ),
        );
      },
    );
  }
}

class SurahRead extends StatefulWidget {
  final int index;
  const SurahRead(this.index, {super.key});

  @override
  State<SurahRead> createState() => _SurahReadState();
}

class _SurahReadState extends State<SurahRead> {
    AudioPlayer audioPlayer = AudioPlayer();
  IconData playpauseButton = Icons.play_circle_fill_rounded;
  bool isPlaying = true;

  @override
  void dispose(){
    audioPlayer.dispose();
    super.dispose();
  }

Future<void> togglebtn() async{
  try {
    final audioUrl = quran.getAudioURLBySurah(widget.index);
    audioPlayer.setUrl(audioUrl);
    if (isPlaying) {
      audioPlayer.play();
      setState(() {
        playpauseButton = Icons.pause_circle_filled_rounded;
        isPlaying = false;
      });
    }else{
      audioPlayer.pause();
      setState(() {
        playpauseButton = Icons.play_circle_fill_rounded;
        isPlaying = true;
      });
    }
  }
  catch (e) {
    print('Error playing audio: $e');
  }
} 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Surah ${widget.index}'),
      ),
      body: surahPage(widget.index),
     
     bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).colorScheme.primary,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center, // Center the button
          children: [
            IconButton(
              icon: Icon(playpauseButton),
              color: Theme.of(context).colorScheme.onSurface, // Icon color
              iconSize: 32, // Size of the icon
              onPressed: togglebtn, // Toggle play/pause action
            ),
          ],
        ),),



    );
  }
}

Widget surahPage(var ayahcount) {
  return ListView.builder(
      itemCount: quran.getVerseCount(ayahcount),
      itemBuilder: (context, index) {
        return Card(
          color: Theme.of(context).colorScheme.onSurface,
          elevation: 4,
          shape: const BeveledRectangleBorder(),
          child: ListTile(
            
            title: Text(
              quran.getVerse(ayahcount, index + 1, verseEndSymbol: true),
              textAlign: TextAlign.right,
              style: surahText(context),
            ),
          ),
        );
      });

}

// Widget surahList(){
//   return ListView.builder(itemCount: quran.totalSurahCount ,itemBuilder: (context, index) {
//         int surahIndex = index + 1;
//           // bool isFavorited = FavSurahClass.isFavSurah(surahIndex)
//     return Card(
//       color: Theme.of(context).colorScheme.onSurface,
//       elevation: 4,
//       shape: BeveledRectangleBorder(),
//       child: ListTile(
//         onTap: (){
//           Navigator.push(context, MaterialPageRoute(builder: (context) => SurahRead(index+1)));
//         },

//           leading: CircleAvatar(radius: 20,backgroundColor: Theme.of(context).colorScheme.primary, child: Text('${index+1}'),),
//           title: Text( quran.getSurahNameArabic(index+1) ,style: surahText(context)),
//           subtitle: Text(quran.getSurahName(index+1) ,style: TextStyle(color:  Theme.of(context).colorScheme.secondary),),
//           trailing: Container(

//             child: Column(children: [
//           //    quran.getPlaceOfRevelation(index+1) == 'Makkah'
//           // ? Image.asset('assets/images/makkah.png', width: 30, height: 30,)
//           // : Image.asset('assets/images/madina.png', width: 30, height: 30,),
//           //  Text('Ayahs ${quran.getVerseCount(index+1)}',),
//            GestureDetector(
//             onTap:(){
//              setState(() {
//                     int surahIndex = index + 1;
//                     if(favSurahClass.favSurah.contains(surahIndex)){
//                       favSurahClass.removeFavSurah(surahIndex);
//                     }else{
//                       favSurahClass.addFavSurah(surahIndex);
//                     }

//                     print(favSurahClass.getFavSurah());
//                   });
//             },
//             child: Icon(Icons.favorite_border),)
//           ],),),
//           ),
//     );
//   });

// }

// class Favorites extends StatefulWidget {
//   final FavSurahClass favSurahClass;
//   Favorites({Key? key, required this.favSurahClass}) : super(key: key);

//   @override
//   State<Favorites> createState() => _FavoritesState();
// }

// class _FavoritesState extends State<Favorites> {
//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       itemCount: quran.totalSurahCount,
//       itemBuilder: (context, index) {
//         int surahIndex = index + 1;
//         bool isFavorited = widget.favSurahClass.favSurah.contains(surahIndex);

//         return Card(
//           color: Theme.of(context).colorScheme.onSurface,
//           elevation: 4,
//           shape: BeveledRectangleBorder(),
//           child: ListTile(
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => SurahRead(index + 1)),
//               );
//             },
//             leading: CircleAvatar(
//               radius: 20,
//               backgroundColor: Theme.of(context).colorScheme.primary,
//               child: Text('${index + 1}'),
//             ),
//             title: Text(
//               quran.getSurahNameArabic(index + 1),
//               style: surahText(context),
//             ),
//             subtitle: Text(
//               quran.getSurahName(index + 1),
//               style: TextStyle(
//                 color: Theme.of(context).colorScheme.secondary,
//               ),
//             ),
//             trailing: Container(
//               child: Column(
//                 children: [
//                   GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         if (isFavorited) {
//                           widget.favSurahClass.removeFavSurah(surahIndex);
//                         } else {
//                           widget.favSurahClass.addFavSurah(surahIndex);
//                         }
//                       });
//                     },
//                     child: Icon(
//                       isFavorited ? Icons.favorite : Icons.favorite_border,
//                       color: isFavorited ? Colors.red : null,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
