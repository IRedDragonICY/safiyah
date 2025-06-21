import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HajjUmrohGuideDetailPage extends StatefulWidget {
  final String guideType;

  const HajjUmrohGuideDetailPage({super.key, required this.guideType});

  @override
  State<HajjUmrohGuideDetailPage> createState() => _HajjUmrohGuideDetailPageState();
}

class _HajjUmrohGuideDetailPageState extends State<HajjUmrohGuideDetailPage> {
  final guideData = {
    'Required Documents': {
      'title': 'Required Documents',
      'icon': Icons.description,
      'sections': [
        {
          'title': 'Essential Documents',
          'content': [
            'Valid passport with minimum 6 months validity',
            'Visa application form (completed)',
            'Passport-sized photographs (4 copies)',
            'Medical certificate from authorized doctor',
            'Vaccination certificate (Yellow fever, if applicable)',
            'Mahram relationship certificate (for women)',
            'Birth certificate (original and copy)',
            'Marriage certificate (if applicable)',
          ]
        },
        {
          'title': 'Financial Documents',
          'content': [
            'Bank statement for last 6 months',
            'Proof of income/employment',
            'Travel insurance policy',
            'Return flight tickets',
            'Hotel booking confirmation',
          ]
        },
        {
          'title': 'Additional Requirements',
          'content': [
            'Police clearance certificate',
            'Educational certificates',
            'Power of attorney (if using agent)',
            'Emergency contact information',
          ]
        }
      ]
    },
    'Health Conditions': {
      'title': 'Health & Medical Requirements',
      'icon': Icons.medical_services,
      'sections': [
        {
          'title': 'Pre-Travel Health Checkup',
          'content': [
            'Complete medical examination by authorized physician',
            'Blood pressure and diabetes screening',
            'Heart condition assessment',
            'Respiratory health evaluation',
            'General fitness certificate',
            'Age-specific health requirements',
          ]
        },
        {
          'title': 'Required Vaccinations',
          'content': [
            'Meningococcal ACWY vaccine (mandatory)',
            'Yellow fever vaccine (if traveling from endemic areas)',
            'Seasonal influenza vaccine (recommended)',
            'COVID-19 vaccination (as per current regulations)',
            'Polio vaccination (if required)',
          ]
        },
        {
          'title': 'Health Precautions',
          'content': [
            'Carry personal medications with prescriptions',
            'Maintain proper hygiene during travel',
            'Stay hydrated in hot climate',
            'Wear comfortable walking shoes',
            'Protect yourself from sun exposure',
            'Follow dietary guidelines',
          ]
        }
      ]
    },
    'Mental & Spiritual Preparation': {
      'title': 'Mental & Spiritual Preparation',
      'icon': Icons.psychology,
      'sections': [
        {
          'title': 'Spiritual Readiness',
          'content': [
            'Learn about the significance of Hajj/Umroh',
            'Study the rituals and their meanings',
            'Increase daily prayers and dhikr',
            'Seek forgiveness from Allah (Tawbah)',
            'Resolve conflicts with family and friends',
            'Make sincere intentions (Niyyah)',
          ]
        },
        {
          'title': 'Mental Preparation',
          'content': [
            'Prepare for crowded and challenging conditions',
            'Practice patience and tolerance',
            'Learn basic Arabic phrases',
            'Understand the schedule and itinerary',
            'Prepare for physical demands',
            'Set realistic expectations',
          ]
        },
        {
          'title': 'Knowledge Requirements',
          'content': [
            'Study Hajj/Umroh procedures thoroughly',
            'Learn the sequence of rituals',
            'Understand the significance of each step',
            'Memorize essential duas and prayers',
            'Know the geography of Makkah and Madinah',
            'Learn about historical sites',
          ]
        }
      ]
    },
    'Hajj/Umroh Equipment': {
      'title': 'Essential Equipment & Packing',
      'icon': Icons.luggage,
      'sections': [
        {
          'title': 'Ihram Clothing',
          'content': [
            'Two pieces of white, unstitched cloth for men',
            'Comfortable modest clothing for women',
            'Extra ihram sets (2-3 recommended)',
            'Belt or safety pins for securing ihram',
            'Flip-flops or sandals without straps',
            'White umbrella for sun protection',
          ]
        },
        {
          'title': 'Personal Items',
          'content': [
            'Toiletries (unscented)',
            'Personal medications',
            'Prayer mat (travel-sized)',
            'Tasbih (prayer beads)',
            'Quran with translation',
            'Hajj/Umroh guidebook',
            'Money belt or pouch',
            'Towels and washcloths',
          ]
        },
        {
          'title': 'Important Accessories',
          'content': [
            'Wheeled luggage for easy transport',
            'Comfortable walking shoes',
            'Sun hat and sunglasses',
            'Water bottle',
            'Small backpack for daily use',
            'Phone charger and power bank',
            'First aid kit',
            'Wet wipes and tissues',
          ]
        }
      ]
    },
    'Pillars of Hajj': {
      'title': 'The Four Pillars of Hajj',
      'icon': Icons.account_balance,
      'sections': [
        {
          'title': '1. Ihram (Sacred State)',
          'content': [
            'Enter the state of Ihram before Miqat',
            'Make intention (Niyyah) for Hajj',
            'Wear the prescribed Ihram clothing',
            'Recite Talbiyah continuously',
            'Observe Ihram restrictions',
            'Maintain ritual purity',
          ]
        },
        {
          'title': '2. Wuquf at Arafat',
          'content': [
            'Most important pillar of Hajj',
            'Stay at Arafat from Zuhr to Maghrib on 9th Dhul Hijjah',
            'Engage in prayer and supplication',
            'Ask for forgiveness and mercy',
            'Listen to the Khutbah if possible',
            'Do not leave before sunset',
          ]
        },
        {
          'title': '3. Tawaf al-Ifadah',
          'content': [
            'Performed after returning from Mina',
            'Seven circumambulations around Kaaba',
            'Start and end at the Black Stone',
            'Recite prescribed prayers',
            'Perform with devotion and humility',
            'Can be done anytime after 10th Dhul Hijjah',
          ]
        },
        {
          'title': '4. Sa\'i between Safa and Marwah',
          'content': [
            'Seven rounds between Safa and Marwah hills',
            'Begin at Safa and end at Marwah',
            'Remember the story of Hajar (AS)',
            'Recite prescribed supplications',
            'Walk normally, run in designated area',
            'Complete all seven rounds',
          ]
        }
      ]
    },
    'Pillars of Umroh': {
      'title': 'The Three Pillars of Umroh',
      'icon': Icons.location_city,
      'sections': [
        {
          'title': '1. Ihram (Sacred State)',
          'content': [
            'Enter Ihram at designated Miqat',
            'Make clear intention for Umroh',
            'Wear Ihram clothing properly',
            'Begin reciting Talbiyah',
            'Follow all Ihram restrictions',
            'Maintain state until completion',
          ]
        },
        {
          'title': '2. Tawaf around Kaaba',
          'content': [
            'Seven circumambulations around Kaaba',
            'Start from Black Stone direction',
            'Keep Kaaba on your left',
            'Recite appropriate duas',
            'Try to touch or kiss Black Stone if possible',
            'Complete all seven rounds',
            'Pray two Rakah at Maqam Ibrahim',
          ]
        },
        {
          'title': '3. Sa\'i between Safa and Marwah',
          'content': [
            'Seven trips between the two hills',
            'Begin at Safa hill',
            'End at Marwah hill',
            'Run between green markers (men only)',
            'Make du\'a at each hill',
            'Remember Hajar\'s search for water',
            'Complete with Halq or Taqsir',
          ]
        }
      ]
    },
    'Ihram Prayers': {
      'title': 'Ihram Prayers & Supplications',
      'icon': Icons.menu_book,
      'sections': [
        {
          'title': 'Talbiyah (Main Recitation)',
          'content': [
            'لَبَّيْكَ اللَّهُمَّ لَبَّيْكَ',
            'لَبَّيْكَ لاَ شَرِيكَ لَكَ لَبَّيْكَ',
            'إِنَّ الْحَمْدَ وَالنِّعْمَةَ لَكَ وَالْمُلْكَ',
            'لاَ شَرِيكَ لَكَ',
            '',
            'English: Here I am, O Allah, here I am.',
            'Here I am, You have no partner, here I am.',
            'Verily all praise, grace and sovereignty belong to You.',
            'You have no partner.',
          ]
        },
        {
          'title': 'Ihram Intention Prayer',
          'content': [
            'اللَّهُمَّ إِنِّي أُرِيدُ الْحَجَّ فَيَسِّرْهُ لِي وَتَقَبَّلْهُ مِنِّي',
            '',
            'English: O Allah, I intend to perform Hajj,',
            'so make it easy for me and accept it from me.',
            '',
            'For Umroh:',
            'اللَّهُمَّ إِنِّي أُرِيدُ الْعُمْرَةَ فَيَسِّرْهَا لِي وَتَقَبَّلْهَا مِنِّي',
            '',
            'English: O Allah, I intend to perform Umroh,',
            'so make it easy for me and accept it from me.',
          ]
        },
        {
          'title': 'General Supplications in Ihram',
          'content': [
            'رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ',
            '',
            'English: Our Lord, give us good in this world',
            'and good in the next world,',
            'and save us from the punishment of the Fire.',
            '',
            'اللَّهُمَّ اغْفِرْ لِي ذَنْبِي وَخَطَئِي وَجَهْلِي',
            '',
            'English: O Allah, forgive my sins,',
            'my mistakes, and my ignorance.',
          ]
        }
      ]
    },
    'Tawaf Prayers': {
      'title': 'Tawaf Prayers & Supplications',
      'icon': Icons.refresh,
      'sections': [
        {
          'title': 'At the Black Stone',
          'content': [
            'بِسْمِ اللَّهِ وَاللَّهُ أَكْبَرُ',
            '',
            'English: In the name of Allah, Allah is Most Great.',
            '',
            'اللَّهُمَّ إِيمَانًا بِكَ وَتَصْدِيقًا بِكِتَابِكَ وَوَفَاءً بِعَهْدِكَ وَاتِّبَاعًا لِسُنَّةِ نَبِيِّكَ مُحَمَّدٍ صَلَّى اللَّهُ عَلَيْهِ وَسَلَّمَ',
            '',
            'English: O Allah, out of faith in You,',
            'belief in Your Book, fulfillment of Your covenant,',
            'and following the Sunnah of Your Prophet Muhammad (SAW).',
          ]
        },
        {
          'title': 'During Tawaf',
          'content': [
            'رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ',
            '',
            'سُبْحَانَ اللَّهِ وَالْحَمْدُ لِلَّهِ وَلَا إِلَهَ إِلَّا اللَّهُ وَاللَّهُ أَكْبَرُ',
            '',
            'English: Glory be to Allah, praise be to Allah,',
            'there is no god but Allah, and Allah is Most Great.',
            '',
            'اللَّهُمَّ اغْفِرْ وَارْحَمْ وَاعْفُ عَمَّا تَعْلَمُ إِنَّكَ أَنْتَ الْأَعَزُّ الْأَكْرَمُ',
            '',
            'English: O Allah, forgive, have mercy,',
            'and pardon what You know.',
            'Indeed, You are the Most Honored, Most Generous.',
          ]
        },
        {
          'title': 'Prayer After Tawaf',
          'content': [
            'Pray 2 Rakah behind Maqam Ibrahim if possible',
            'Or anywhere in the Haram if crowded',
            '',
            'First Rakah: Recite Surah Al-Kafirun after Al-Fatiha',
            'Second Rakah: Recite Surah Al-Ikhlas after Al-Fatiha',
            '',
            'After prayer, make personal supplications',
            'Drink Zamzam water with intention',
            'Proceed to Safa for Sa\'i',
          ]
        }
      ]
    },
    'Sa\'i Prayers': {
      'title': 'Sa\'i Prayers & Supplications',
      'icon': Icons.directions_run,
      'sections': [
        {
          'title': 'At Safa Hill',
          'content': [
            'إِنَّ الصَّفَا وَالْمَرْوَةَ مِنْ شَعَائِرِ اللَّهِ',
            '',
            'English: Indeed, Safa and Marwah are among',
            'the symbols of Allah.',
            '',
            'Face the Kaaba and raise your hands:',
            'لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ يُحْيِي وَيُمِيتُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ',
            '',
            'English: There is no god but Allah alone,',
            'with no partner. His is the dominion',
            'and His is the praise. He gives life and death',
            'and He has power over all things.',
          ]
        },
        {
          'title': 'At Marwah Hill',
          'content': [
            'Same recitation as at Safa:',
            'لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ',
            '',
            'Add personal supplications:',
            'اللَّهُمَّ اغْفِرْ لِي ذُنُوبِي وَخَطَايَايَ',
            '',
            'English: O Allah, forgive my sins and my mistakes.',
            '',
            'رَبِّ اغْفِرْ وَارْحَمْ إِنَّكَ أَنْتَ الْأَعَزُّ الْأَكْرَمُ',
            '',
            'English: My Lord, forgive and have mercy,',
            'indeed You are the Most Honored, Most Generous.',
          ]
        },
        {
          'title': 'During Sa\'i',
          'content': [
            'Recite Quran, dhikr, and personal supplications',
            'Remember the story of Hajar (AS)',
            'Ask Allah for your needs',
            'Pray for family, community, and Ummah',
            '',
            'Common recitations:',
            'رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ',
            '',
            'سُبْحَانَ اللَّهِ وَالْحَمْدُ لِلَّهِ وَلَا إِلَهَ إِلَّا اللَّهُ وَاللَّهُ أَكْبَرُ',
          ]
        }
      ]
    },
    'Wuquf Prayers': {
      'title': 'Wuquf at Arafat Prayers',
      'icon': Icons.landscape,
      'sections': [
        {
          'title': 'Best Time for Supplication',
          'content': [
            'From Zuhr prayer until Maghrib',
            'The most blessed time is before sunset',
            'Face the Qiblah if possible',
            'Raise hands in humility',
            'Make sincere repentance (Tawbah)',
            'Ask for forgiveness and mercy',
          ]
        },
        {
          'title': 'Recommended Supplications',
          'content': [
            'لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ بِيَدِهِ الْخَيْرُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ',
            '',
            'اللَّهُمَّ لَكَ الْحَمْدُ كَالَّذِي نَقُولُ وَخَيْرًا مِمَّا نَقُولُ اللَّهُمَّ لَكَ صَلَاتِي وَنُسُكِي وَمَحْيَايَ وَمَمَاتِي وَإِلَيْكَ مَآبِي وَلَكَ رَبِّ تُرَاثِي',
            '',
            'English: O Allah, to You belongs all praise',
            'as we say and better than what we say.',
            'O Allah, to You belongs my prayer, my worship,',
            'my life and my death, to You is my return,',
            'and to You, my Lord, belongs my inheritance.',
          ]
        },
        {
          'title': 'Personal Supplications',
          'content': [
            'Ask forgiveness for all sins',
            'Pray for guidance and righteousness',
            'Suppliccate for family and loved ones',
            'Pray for the Muslim Ummah',
            'Ask for success in this life and the hereafter',
            'Make du\'a in your own language if needed',
            'Recite Quran and dhikr',
            'Remember Allah abundantly',
          ]
        }
      ]
    }
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final guide = guideData[widget.guideType];

    if (guide == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Guide Not Found')),
        body: const Center(
          child: Text('The requested guide could not be found.'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainer,
      appBar: AppBar(
        title: Text(guide['title'] as String),
        backgroundColor: colorScheme.surface,
        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Guide bookmarked for offline reading')),
              );
            },
            icon: const Icon(Icons.bookmark_border),
          ),
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sharing guide...')),
              );
            },
            icon: const Icon(Icons.share),
          ),
        ],
      ),
      body: _buildGuideContent(context, widget.guideType),
    );
  }

  Widget _buildGuideContent(BuildContext context, String type) {
    switch (type) {
      case 'Required Documents':
        return _buildDocumentGuide(context);
      case 'Health Conditions':
        return _buildHealthGuide(context);
      case 'Mental & Spiritual Preparation':
        return _buildSpiritualGuide(context);
      case 'Hajj/Umroh Equipment':
        return _buildEquipmentGuide(context);
      case 'Pillars of Hajj':
        return _buildHajjPillarsGuide(context);
      case 'Pillars of Umroh':
        return _buildUmrohPillarsGuide(context);
      case 'Sunnah of Hajj':
        return _buildHajjSunnahGuide(context);
      case 'Prohibitions in Ihram':
        return _buildIhramProhibitionsGuide(context);
      case 'Ihram Prayers':
        return _buildIhramPrayersGuide(context);
      case 'Tawaf Prayers':
        return _buildTawafPrayersGuide(context);
      case 'Sa\'i Prayers':
        return _buildSaiPrayersGuide(context);
      case 'Wuquf Prayers':
        return _buildWuqufPrayersGuide(context);
      default:
        return _buildDefaultGuide(context, type);
    }
  }

  Widget _buildDocumentGuide(BuildContext context) {
    final sections = [
      {
        'title': 'Essential Documents',
        'icon': Icons.description,
        'items': [
          'Valid passport with minimum 6 months validity',
          'Visa application form (completed)',
          'Passport-sized photographs (4 copies)',
          'Medical certificate from authorized doctor',
          'Vaccination certificate (Yellow fever, if applicable)',
          'Mahram relationship certificate (for women)',
          'Birth certificate (original and copy)',
          'Marriage certificate (if applicable)',
        ]
      },
      {
        'title': 'Financial Documents',
        'icon': Icons.attach_money,
        'items': [
          'Bank statement for last 6 months',
          'Proof of income/employment',
          'Travel insurance policy',
          'Return flight tickets',
          'Hotel booking confirmation',
        ]
      },
      {
        'title': 'Additional Requirements',
        'icon': Icons.add_circle,
        'items': [
          'Police clearance certificate',
          'Educational certificates',
          'Power of attorney (if using agent)',
          'Emergency contact information',
        ]
      }
    ];

    return _buildSectionList(context, sections);
  }

  Widget _buildHealthGuide(BuildContext context) {
    final sections = [
      {
        'title': 'Pre-Travel Health Checkup',
        'icon': Icons.medical_services,
        'items': [
          'Complete medical examination by authorized physician',
          'Blood pressure and diabetes screening',
          'Heart condition assessment',
          'Respiratory health evaluation',
          'General fitness certificate',
          'Age-specific health requirements',
        ]
      },
      {
        'title': 'Required Vaccinations',
        'icon': Icons.vaccines,
        'items': [
          'Meningococcal ACWY vaccine (mandatory)',
          'Yellow fever vaccine (if traveling from endemic areas)',
          'Seasonal influenza vaccine (recommended)',
          'COVID-19 vaccination (as per current regulations)',
          'Polio vaccination (if required)',
        ]
      },
      {
        'title': 'Health Precautions',
        'icon': Icons.health_and_safety,
        'items': [
          'Carry personal medications with prescriptions',
          'Maintain proper hygiene during travel',
          'Stay hydrated in hot climate',
          'Wear comfortable walking shoes',
          'Protect yourself from sun exposure',
          'Follow dietary guidelines',
        ]
      }
    ];

    return _buildSectionList(context, sections);
  }

  Widget _buildSpiritualGuide(BuildContext context) {
    final sections = [
      {
        'title': 'Spiritual Readiness',
        'icon': Icons.psychology,
        'items': [
          'Learn about the significance of Hajj/Umroh',
          'Study the rituals and their meanings',
          'Increase daily prayers and dhikr',
          'Seek forgiveness from Allah (Tawbah)',
          'Resolve conflicts with family and friends',
          'Make sincere intentions (Niyyah)',
        ]
      },
      {
        'title': 'Mental Preparation',
        'icon': Icons.self_improvement,
        'items': [
          'Prepare for crowded and challenging conditions',
          'Practice patience and tolerance',
          'Learn basic Arabic phrases',
          'Understand the schedule and itinerary',
          'Prepare for physical demands',
          'Set realistic expectations',
        ]
      },
      {
        'title': 'Knowledge Requirements',
        'icon': Icons.school,
        'items': [
          'Study Hajj/Umroh procedures thoroughly',
          'Learn the sequence of rituals',
          'Understand the significance of each step',
          'Memorize essential duas and prayers',
          'Know the geography of Makkah and Madinah',
          'Learn about historical sites',
        ]
      }
    ];

    return _buildSectionList(context, sections);
  }

  Widget _buildEquipmentGuide(BuildContext context) {
    final sections = [
      {
        'title': 'Ihram Clothing',
        'icon': Icons.checkroom,
        'items': [
          'Two pieces of white, unstitched cloth for men',
          'Comfortable modest clothing for women',
          'Extra ihram sets (2-3 recommended)',
          'Belt or safety pins for securing ihram',
          'Flip-flops or sandals without straps',
          'White umbrella for sun protection',
        ]
      },
      {
        'title': 'Personal Items',
        'icon': Icons.luggage,
        'items': [
          'Toiletries (unscented)',
          'Personal medications',
          'Prayer mat (travel-sized)',
          'Tasbih (prayer beads)',
          'Quran with translation',
          'Hajj/Umroh guidebook',
          'Money belt or pouch',
          'Towels and washcloths',
        ]
      },
      {
        'title': 'Important Accessories',
        'icon': Icons.backpack,
        'items': [
          'Wheeled luggage for easy transport',
          'Comfortable walking shoes',
          'Sun hat and sunglasses',
          'Water bottle',
          'Small backpack for daily use',
          'Phone charger and power bank',
          'First aid kit',
          'Wet wipes and tissues',
        ]
      }
    ];

    return _buildSectionList(context, sections);
  }

  Widget _buildHajjPillarsGuide(BuildContext context) {
    final sections = [
      {
        'title': '1. Ihram (Sacred State)',
        'icon': Icons.person,
        'items': [
          'Enter the state of Ihram before Miqat',
          'Make intention (Niyyah) for Hajj',
          'Wear the prescribed Ihram clothing',
          'Recite Talbiyah continuously',
          'Observe Ihram restrictions',
          'Maintain ritual purity',
        ]
      },
      {
        'title': '2. Wuquf at Arafat',
        'icon': Icons.landscape,
        'items': [
          'Most important pillar of Hajj',
          'Stay at Arafat from Zuhr to Maghrib on 9th Dhul Hijjah',
          'Engage in prayer and supplication',
          'Ask for forgiveness and mercy',
          'Listen to the Khutbah if possible',
          'Do not leave before sunset',
        ]
      },
      {
        'title': '3. Tawaf al-Ifadah',
        'icon': Icons.refresh,
        'items': [
          'Performed after returning from Mina',
          'Seven circumambulations around Kaaba',
          'Start and end at the Black Stone',
          'Recite prescribed prayers',
          'Perform with devotion and humility',
          'Can be done anytime after 10th Dhul Hijjah',
        ]
      },
      {
        'title': '4. Sa\'i between Safa and Marwah',
        'icon': Icons.directions_run,
        'items': [
          'Seven rounds between Safa and Marwah hills',
          'Begin at Safa and end at Marwah',
          'Remember the story of Hajar (AS)',
          'Recite prescribed supplications',
          'Walk normally, run in designated area',
          'Complete all seven rounds',
        ]
      }
    ];

    return _buildSectionList(context, sections);
  }

  Widget _buildUmrohPillarsGuide(BuildContext context) {
    final sections = [
      {
        'title': '1. Ihram (Sacred State)',
        'icon': Icons.person,
        'items': [
          'Enter Ihram at designated Miqat',
          'Make clear intention for Umroh',
          'Wear Ihram clothing properly',
          'Begin reciting Talbiyah',
          'Follow all Ihram restrictions',
          'Maintain state until completion',
        ]
      },
      {
        'title': '2. Tawaf around Kaaba',
        'icon': Icons.refresh,
        'items': [
          'Seven circumambulations around Kaaba',
          'Start from Black Stone direction',
          'Keep Kaaba on your left',
          'Recite appropriate duas',
          'Try to touch or kiss Black Stone if possible',
          'Complete all seven rounds',
          'Pray two Rakah at Maqam Ibrahim',
        ]
      },
      {
        'title': '3. Sa\'i between Safa and Marwah',
        'icon': Icons.directions_run,
        'items': [
          'Seven trips between the two hills',
          'Begin at Safa hill',
          'End at Marwah hill',
          'Run between green markers (men only)',
          'Make du\'a at each hill',
          'Remember Hajar\'s search for water',
          'Complete with Halq or Taqsir',
        ]
      }
    ];

    return _buildSectionList(context, sections);
  }

  Widget _buildHajjSunnahGuide(BuildContext context) {
    final sections = [
      {
        'title': 'Sunnah Acts of Hajj',
        'icon': Icons.star,
        'items': [
          'Ghusl (ritual bath) before Ihram',
          'Two Rakah prayer before Ihram',
          'Reciting Talbiyah frequently',
          'Entering Masjid al-Haram with right foot',
          'Kissing or touching the Black Stone',
          'Drinking Zamzam water',
          'Climbing Mount Safa and Marwah',
          'Staying in Mina on 11th and 12th Dhul Hijjah',
          'Throwing stones at all three Jamarat',
          'Farewell Tawaf (Tawaf al-Wada)',
        ]
      }
    ];

    return _buildSectionList(context, sections);
  }

  Widget _buildIhramProhibitionsGuide(BuildContext context) {
    final sections = [
      {
        'title': 'For Men',
        'icon': Icons.man,
        'items': [
          'Wearing stitched clothing',
          'Covering the head',
          'Wearing shoes that cover the ankle',
          'Using perfume or scented products',
          'Cutting hair or nails',
          'Sexual relations',
          'Hunting or killing animals',
          'Getting married or performing marriage',
        ]
      },
      {
        'title': 'For Women',
        'icon': Icons.woman,
        'items': [
          'Wearing face veil (niqab)',
          'Wearing gloves',
          'Using perfume or scented products',
          'Cutting hair or nails',
          'Sexual relations',
          'Hunting or killing animals',
          'Getting married or performing marriage',
          'Covering hands and feet is allowed',
        ]
      },
      {
        'title': 'Common Prohibitions',
        'icon': Icons.block,
        'items': [
          'Arguing, fighting, or using foul language',
          'Engaging in sinful behavior',
          'Smoking or consuming alcohol',
          'Cutting trees or plants in the Haram',
          'Removing lice from hair or body',
          'Using soap or shampoo with fragrance',
        ]
      }
    ];

    return _buildSectionList(context, sections);
  }

  Widget _buildIhramPrayersGuide(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPrayerCard(
            'Talbiyah (Main Recitation)',
            [
              'لَبَّيْكَ اللَّهُمَّ لَبَّيْكَ',
              'لَبَّيْكَ لاَ شَرِيكَ لَكَ لَبَّيْكَ',
              'إِنَّ الْحَمْدَ وَالنِّعْمَةَ لَكَ وَالْمُلْكَ',
              'لاَ شَرِيكَ لَكَ',
              '',
              'English: Here I am, O Allah, here I am.',
              'Here I am, You have no partner, here I am.',
              'Verily all praise, grace and sovereignty belong to You.',
              'You have no partner.',
            ],
          ),
          _buildPrayerCard(
            'Ihram Intention Prayer',
            [
              'اللَّهُمَّ إِنِّي أُرِيدُ الْحَجَّ فَيَسِّرْهُ لِي وَتَقَبَّلْهُ مِنِّي',
              '',
              'English: O Allah, I intend to perform Hajj,',
              'so make it easy for me and accept it from me.',
              '',
              'For Umroh:',
              'اللَّهُمَّ إِنِّي أُرِيدُ الْعُمْرَةَ فَيَسِّرْهَا لِي وَتَقَبَّلْهَا مِنِّي',
              '',
              'English: O Allah, I intend to perform Umroh,',
              'so make it easy for me and accept it from me.',
            ],
          ),
          _buildPrayerCard(
            'General Supplications in Ihram',
            [
              'رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ',
              '',
              'English: Our Lord, give us good in this world',
              'and good in the next world,',
              'and save us from the punishment of the Fire.',
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTawafPrayersGuide(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPrayerCard(
            'At the Black Stone',
            [
              'بِسْمِ اللَّهِ وَاللَّهُ أَكْبَرُ',
              '',
              'English: In the name of Allah, Allah is Most Great.',
            ],
          ),
          _buildPrayerCard(
            'During Tawaf',
            [
              'رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ',
              '',
              'English: Glory be to Allah, praise be to Allah,',
              'there is no god but Allah, and Allah is Most Great.',
            ],
          ),
          _buildPrayerCard(
            'Prayer After Tawaf',
            [
              '• Pray 2 Rakah behind Maqam Ibrahim if possible',
              '• Or anywhere in the Haram if crowded',
              '• First Rakah: Recite Surah Al-Kafirun after Al-Fatiha',
              '• Second Rakah: Recite Surah Al-Ikhlas after Al-Fatiha',
              '• Drink Zamzam water with intention',
              '• Proceed to Safa for Sa\'i',
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSaiPrayersGuide(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPrayerCard(
            'At Safa and Marwah Hills',
            [
              'إِنَّ الصَّفَا وَالْمَرْوَةَ مِنْ شَعَائِرِ اللَّهِ',
              '',
              'English: Indeed, Safa and Marwah are among',
              'the symbols of Allah.',
              '',
              'Face the Kaaba and raise your hands:',
              'لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ',
              '',
              'English: There is no god but Allah alone,',
              'with no partner.',
            ],
          ),
          _buildPrayerCard(
            'During Sa\'i',
            [
              '• Recite Quran, dhikr, and personal supplications',
              '• Remember the story of Hajar (AS)',
              '• Ask Allah for your needs',
              '• Pray for family, community, and Ummah',
              '• Make du\'a in your own language if needed',
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWuqufPrayersGuide(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPrayerCard(
            'Best Time for Supplication',
            [
              '• From Zuhr prayer until Maghrib',
              '• The most blessed time is before sunset',
              '• Face the Qiblah if possible',
              '• Raise hands in humility',
              '• Make sincere repentance (Tawbah)',
              '• Ask for forgiveness and mercy',
            ],
          ),
          _buildPrayerCard(
            'Recommended Supplications',
            [
              'لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ',
              '',
              'English: There is no god but Allah alone,',
              'with no partner. His is the dominion and His is the praise.',
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultGuide(BuildContext context, String type) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.menu_book,
            size: 64,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            type,
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'Detailed guide content coming soon...',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionList(BuildContext context, List<Map<String, dynamic>> sections) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sections.length,
      itemBuilder: (context, index) {
        final section = sections[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: ExpansionTile(
            title: Text(
              section['title'] as String,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            leading: Icon(
              section['icon'] as IconData,
              color: Theme.of(context).colorScheme.primary,
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: (section['items'] as List<String>).map((item) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.check_circle, color: Colors.green, size: 16),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(item),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPrayerCard(String title, List<String> content) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            ...content.map((item) {
              final isArabic = RegExp(r'[\u0600-\u06FF]').hasMatch(item);
              final isTranslation = item.startsWith('Translation:');
              
              if (item.isEmpty) {
                return const SizedBox(height: 8);
              }
              
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  item,
                  style: TextStyle(
                    fontSize: isArabic ? 18 : 14,
                    fontWeight: isArabic ? FontWeight.bold : 
                               isTranslation ? FontWeight.w600 : FontWeight.normal,
                    color: isArabic ? Theme.of(context).colorScheme.primary :
                           isTranslation ? Theme.of(context).colorScheme.secondary : null,
                    height: isArabic ? 1.8 : 1.4,
                  ),
                  textAlign: isArabic ? TextAlign.right : TextAlign.left,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
} 