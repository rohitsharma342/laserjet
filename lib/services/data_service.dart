import '../models/printer.dart';
import '../models/user.dart';
import '../utils/constants.dart';

class DataService {
  static List<Printer> get samplePrinters {
    return [
      Printer(
        id: '1',
        name: 'HP LaserJet Pro M404n',
        brand: 'HP',
        price: 299.99,
        category: 'Laser',
        images: [
          '${AppConstants.unsplashBaseUrl}/400x300/?printer,laser,office',
          '${AppConstants.unsplashBaseUrl}/400x300/?printer,technology',
        ],
        specifications: {
          'Print Speed': 'Up to 38 ppm',
          'Print Resolution': '1200 x 1200 dpi',
          'Paper Size': 'A4, Letter, Legal',
          'Connectivity': 'USB, Ethernet',
          'Memory': '256 MB',
        },
        description: 'Professional laser printer designed for high-volume printing with excellent speed and quality.',
        rating: 4.5,
        reviewCount: 124,
        isTrending: true,
      ),
      Printer(
        id: '2',
        name: 'Canon PIXMA TR4520',
        brand: 'Canon',
        price: 89.99,
        category: 'Inkjet',
        images: [
          '${AppConstants.unsplashBaseUrl}/400x300/?printer,inkjet,home',
          '${AppConstants.unsplashBaseUrl}/400x300/?printer,compact',
        ],
        specifications: {
          'Print Speed': 'Up to 8.8 ipm',
          'Print Resolution': '4800 x 1200 dpi',
          'Paper Size': 'A4, Letter, 4x6',
          'Connectivity': 'WiFi, USB',
          'Functions': 'Print, Scan, Copy, Fax',
        },
        description: 'All-in-one wireless printer perfect for home office with compact design.',
        rating: 4.2,
        reviewCount: 89,
        isTrending: false,
      ),
      Printer(
        id: '3',
        name: 'Epson EcoTank ET-2720',
        brand: 'Epson',
        price: 199.99,
        category: 'Inkjet',
        images: [
          '${AppConstants.unsplashBaseUrl}/400x300/?printer,ecotank,white',
          '${AppConstants.unsplashBaseUrl}/400x300/?printer,cartridge',
        ],
        specifications: {
          'Print Speed': 'Up to 10 ppm',
          'Print Resolution': '5760 x 1440 dpi',
          'Paper Size': 'A4, Letter',
          'Connectivity': 'WiFi, USB',
          'Tank System': '2 years of ink included',
        },
        description: 'Revolutionary cartridge-free printing with 2 years of ink included.',
        rating: 4.7,
        reviewCount: 256,
        isTrending: true,
      ),
      Printer(
        id: '4',
        name: 'HP OfficeJet Pro 9015e',
        brand: 'HP',
        price: 179.99,
        category: 'Multifunction',
        images: [
          '${AppConstants.unsplashBaseUrl}/400x300/?printer,office,black',
          '${AppConstants.unsplashBaseUrl}/400x300/?multifunction,scanner',
        ],
        specifications: {
          'Print Speed': 'Up to 22 ppm',
          'Print Resolution': '1200 x 1200 dpi',
          'Paper Size': 'A4, Letter, Legal',
          'Connectivity': 'WiFi, Ethernet, USB',
          'Functions': 'Print, Scan, Copy, Fax',
        },
        description: 'Smart all-in-one printer with advanced security and mobile printing.',
        rating: 4.4,
        reviewCount: 178,
        isTrending: false,
      ),
      Printer(
        id: '5',
        name: 'Canon Selphy CP1300',
        brand: 'Canon',
        price: 129.99,
        category: 'Portable',
        images: [
          '${AppConstants.unsplashBaseUrl}/400x300/?portable,printer,small',
          '${AppConstants.unsplashBaseUrl}/400x300/?photo,printer',
        ],
        specifications: {
          'Print Speed': '47 seconds per photo',
          'Print Size': '4x6 inch',
          'Connectivity': 'WiFi, USB',
          'Battery': 'Optional battery pack',
          'Paper Type': 'Photo paper only',
        },
        description: 'Compact wireless photo printer for instant printing on the go.',
        rating: 4.3,
        reviewCount: 95,
        isTrending: true,
      ),
      Printer(
        id: '6',
        name: 'Creality Ender 3 V2',
        brand: 'Creality',
        price: 259.99,
        category: '3D Printers',
        images: [
          '${AppConstants.unsplashBaseUrl}/400x300/?3d,printer,technology',
          '${AppConstants.unsplashBaseUrl}/400x300/?3d,printing,maker',
        ],
        specifications: {
          'Build Volume': '220 x 220 x 250mm',
          'Layer Resolution': '0.1-0.4mm',
          'Filament': '1.75mm PLA, ABS, PETG',
          'Connectivity': 'SD Card, USB',
          'Heated Bed': 'Yes',
        },
        description: 'Popular entry-level 3D printer with excellent build quality and community support.',
        rating: 4.6,
        reviewCount: 312,
        isTrending: true,
      ),
    ];
  }

  static User get sampleUser {
    return User(
      id: 'user_1',
      name: 'John Doe',
      email: 'john.doe@example.com',
      avatar: '${AppConstants.unsplashBaseUrl}/100x100/?portrait,professional',
      orderHistory: [
        Order(
          id: 'ORD001',
          date: DateTime.now().subtract(const Duration(days: 7)),
          status: 'Delivered',
          total: 299.99,
          items: ['HP LaserJet Pro M404n'],
        ),
        Order(
          id: 'ORD002',
          date: DateTime.now().subtract(const Duration(days: 21)),
          status: 'Delivered',
          total: 89.99,
          items: ['Canon PIXMA TR4520'],
        ),
      ],
    );
  }

  static List<Printer> searchPrinters(String query, {String? category}) {
    List<Printer> printers = samplePrinters;
    
    if (category != null && category != 'All') {
      printers = printers.where((p) => p.category == category).toList();
    }
    
    if (query.isNotEmpty) {
      printers = printers.where((p) =>
        p.name.toLowerCase().contains(query.toLowerCase()) ||
        p.brand.toLowerCase().contains(query.toLowerCase())
      ).toList();
    }
    
    return printers;
  }

  static List<Printer> getTrendingPrinters() {
    return samplePrinters.where((p) => p.isTrending).toList();
  }
}