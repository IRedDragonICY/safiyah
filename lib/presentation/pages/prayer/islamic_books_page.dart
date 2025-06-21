import 'package:flutter/material.dart';

import '../../../core/constants/colors.dart';
import '../../../data/models/islamic_book_model.dart';

class IslamicBooksPage extends StatefulWidget {
  const IslamicBooksPage({super.key});

  @override
  State<IslamicBooksPage> createState() => _IslamicBooksPageState();
}

class _IslamicBooksPageState extends State<IslamicBooksPage> with TickerProviderStateMixin {
  late TabController _tabController;
  BookCategory _selectedCategory = BookCategory.prophetsStories;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Islamic Books'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Categories', icon: Icon(Icons.category)),
            Tab(text: 'Library', icon: Icon(Icons.library_books)),
            Tab(text: 'Downloads', icon: Icon(Icons.download)),
            Tab(text: 'Reading', icon: Icon(Icons.chrome_reader_mode)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildCategoriesTab(),
          _buildLibraryTab(),
          _buildDownloadsTab(),
          _buildReadingTab(),
        ],
      ),
    );
  }

  Widget _buildCategoriesTab() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.1,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
      ),
      itemCount: BookCategory.values.length,
      itemBuilder: (context, index) {
        final category = BookCategory.values[index];
        return Card(
          child: InkWell(
            onTap: () {
              setState(() {
                _selectedCategory = category;
                _tabController.animateTo(1);
              });
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(_getCategoryIcon(category), size: 32, color: Colors.blue.shade600),
                  const SizedBox(height: 8),
                  Text(_getCategoryName(category), 
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center),
                  Text('${_getCategoryCount(category)} books', 
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLibraryTab() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          child: DropdownButtonFormField<BookCategory>(
            value: _selectedCategory,
            decoration: const InputDecoration(
              labelText: 'Category',
              border: OutlineInputBorder(),
            ),
            items: BookCategory.values.map((category) {
              return DropdownMenuItem(
                value: category,
                child: Text(_getCategoryName(category)),
              );
            }).toList(),
            onChanged: (value) => setState(() => _selectedCategory = value!),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: 10,
            itemBuilder: (context, index) => _buildBookCard(_getSampleBook(index)),
          ),
        ),
      ],
    );
  }

  Widget _buildDownloadsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (context, index) => _buildBookCard(_getSampleBook(index, isDownloaded: true)),
    );
  }

  Widget _buildReadingTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 3,
      itemBuilder: (context, index) => _buildReadingProgressCard(_getSampleBook(index)),
    );
  }

  Widget _buildBookCard(IslamicBookModel book) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade300),
              ),
              child: Icon(Icons.book, color: Colors.blue.shade600, size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(book.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text('by ${book.author}', style: TextStyle(color: Colors.grey.shade600)),
                  const SizedBox(height: 4),
                  Text(book.description, maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 16),
                      Text(' ${book.rating}'),
                      const SizedBox(width: 8),
                      Text('${book.totalPages} pages'),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(_getCategoryName(book.category), 
                          style: TextStyle(fontSize: 10, color: Colors.blue.shade700)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              children: [
                IconButton(
                  icon: Icon(book.isDownloaded ? Icons.download_done : Icons.download),
                  onPressed: () => _downloadBook(book),
                  color: book.isDownloaded ? Colors.green : Colors.blue,
                ),
                IconButton(
                  icon: Icon(book.isFavorite ? Icons.favorite : Icons.favorite_border),
                  onPressed: () => _toggleFavorite(book),
                  color: book.isFavorite ? Colors.red : Colors.grey,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReadingProgressCard(IslamicBookModel book) {
    final progress = 0.3; // Sample progress
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(book.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text('by ${book.author}', style: TextStyle(color: Colors.grey.shade600)),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _continueReading(book),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade600),
                  child: const Text('Continue'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey.shade300,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade600),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${(progress * 100).round()}% completed'),
                Text('Chapter 3 of 10'),
              ],
            ),
            const SizedBox(height: 8),
            Text('Last read: 2 hours ago', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(BookCategory category) {
    switch (category) {
      case BookCategory.prophetsStories: return Icons.person;
      case BookCategory.companionsStories: return Icons.group;
      case BookCategory.islamicHistory: return Icons.history_edu;
      case BookCategory.motivational: return Icons.psychology;
      case BookCategory.spirituality: return Icons.self_improvement;
      case BookCategory.fiqh: return Icons.gavel;
      case BookCategory.aqidah: return Icons.favorite;
      case BookCategory.seerah: return Icons.account_circle;
      case BookCategory.children: return Icons.child_care;
      case BookCategory.family: return Icons.family_restroom;
      default: return Icons.book;
    }
  }

  String _getCategoryName(BookCategory category) {
    switch (category) {
      case BookCategory.prophetsStories: return 'Prophets Stories';
      case BookCategory.companionsStories: return 'Companions Stories';
      case BookCategory.islamicHistory: return 'Islamic History';
      case BookCategory.motivational: return 'Motivational';
      case BookCategory.spirituality: return 'Spirituality';
      case BookCategory.fiqh: return 'Fiqh';
      case BookCategory.aqidah: return 'Aqidah';
      case BookCategory.seerah: return 'Seerah';
      case BookCategory.biography: return 'Biography';
      case BookCategory.children: return 'Children';
      case BookCategory.youth: return 'Youth';
      case BookCategory.women: return 'Women';
      case BookCategory.family: return 'Family';
      case BookCategory.ethics: return 'Ethics';
      default: return 'General';
    }
  }

  int _getCategoryCount(BookCategory category) => 15;

  IslamicBookModel _getSampleBook(int index, {bool isDownloaded = false}) {
    final sampleBooks = [
      {'title': 'Stories of the Prophets', 'author': 'Ibn Kathir', 'category': BookCategory.prophetsStories},
      {'title': 'The Sealed Nectar', 'author': 'Safi-ur-Rahman al-Mubarakpuri', 'category': BookCategory.seerah},
      {'title': 'Lives of the Sahabah', 'author': 'Maulana Muhammad Yusuf Kandhlawi', 'category': BookCategory.companionsStories},
    ];

    final bookData = sampleBooks[index % sampleBooks.length];
    
    return IslamicBookModel(
      id: 'book_$index',
      title: bookData['title']! as String,
      author: bookData['author']! as String,
      description: 'A comprehensive book about Islamic teachings and stories that inspire faith and character.',
      category: bookData['category']! as BookCategory,
      coverImageUrl: '',
      chapters: [],
      language: 'English',
      totalPages: 200 + (index * 50),
      rating: 4.5,
      totalReviews: 1200,
      isDownloaded: isDownloaded,
      isFavorite: index % 3 == 0,
      publishedDate: DateTime(2020, 1, 1),
      tags: ['islamic', 'education', 'spiritual'],
    );
  }

  void _downloadBook(IslamicBookModel book) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(book.isDownloaded ? 'Book already downloaded' : 'Downloading ${book.title}...'),
      ),
    );
  }

  void _toggleFavorite(IslamicBookModel book) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(book.isFavorite ? 'Removed from favorites' : 'Added to favorites'),
      ),
    );
  }

  void _continueReading(IslamicBookModel book) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening ${book.title}...')),
    );
  }
} 