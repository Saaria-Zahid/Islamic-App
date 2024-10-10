import 'package:al_quran/favorite.dart';
import 'package:al_quran/surahs.dart';
import 'package:al_quran/theme_styling/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:quran/quran.dart' as quran;
import 'package:google_fonts/google_fonts.dart';



class TranslatedQuran extends StatefulWidget {
  const TranslatedQuran({super.key});

  @override
  State<TranslatedQuran> createState() => _TranslatedQuranState();
}

class _TranslatedQuranState extends State<TranslatedQuran> {
  final FavSurahClass favSurahClass = FavSurahClass();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TranslatedQuran'),
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
                MaterialPageRoute(builder: (context) => Translations(surahIndex)),
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
            trailing: GestureDetector(
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


class Translations extends StatefulWidget {
  final int surahIndex;
  const Translations(this.surahIndex, {super.key});

  @override
  State<Translations> createState() => _TranslationsState();
}

class _TranslationsState extends State<Translations> {
  dynamic defaultTranslation = quran.Translation.enSaheeh;
  Map<String, dynamic> translations = {
    "English (Saheeh International)": quran.Translation.enSaheeh,
    "English (Clear Quran)": quran.Translation.enClearQuran,
    "French (Muhammad Hamidullah)": quran.Translation.frHamidullah,
    "Turkish": quran.Translation.trSaheeh,
    "Malayalam": quran.Translation.mlAbdulHameed,
    "Farsi": quran.Translation.faHusseinDari,
    "Portuguese": quran.Translation.pt,
    "Italian": quran.Translation.itPiccardo,
    "Dutch": quran.Translation.nlSiregar,
    "Russian": quran.Translation.ruKuliev
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Quran Translations'),
        ),
        body: Column(
          children: [
             Card(
              color: Theme.of(context).colorScheme.primary,
               child: Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: DropdownButton<dynamic>(
                dropdownColor: Theme.of(context).colorScheme.primary,
                icon: const Icon(
                  Icons.arrow_drop_down_circle,
                  size: 16,
                ),
                isDense: true,
                iconSize: 16,
                value: defaultTranslation,
                items: translations.entries.map((entry) {
                  return DropdownMenuItem<dynamic>(
                    value: entry.value,
                    child: Text(entry.key, style: primaryText(context)),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    defaultTranslation = value!;
                  });
                },
                           ),
                         ),
             ),
          
            Expanded(
              
              child: Container(
                child: ListView.builder(
                    itemCount: quran.getVerseCount(1),
                    itemBuilder: (context, index) {
                      return Card(
                        color: Theme.of(context).colorScheme.onSurface,
                        elevation: 4,
                        shape: const BeveledRectangleBorder(),
                        child: ListTile(
                          title: Text(
                            quran.getVerseTranslation(widget.surahIndex, index+1, translation: defaultTranslation),
                            style: surahText(context),
                          ),
                        ),
                      );
                    }),
              ),
            )
          ],
        ));
  }
}
