import '../models/product.dart';
import '../models/user.dart';

class DataService {
  static List<Product> getProducts() {
    return [
      Product(
        id: '1',
        name: 'HP LaserJet Pro M404n',
        description: 'Fast, reliable monochrome laser printer perfect for small offices',
        price: 229.99,
        images: [
          'https://images.unsplash.com/photo-1612198188060-c7c2a3b66eae?w=500',
          'https://images.unsplash.com/photo-1541410965313-d53b3c16ef17?w=500',
        ],
        category: 'Laser',
        brand: 'HP',
        specifications: {
          'Print Speed': '38 ppm',
          'Resolution': '4800 x 600 dpi',
          'Connectivity': 'USB, Ethernet',
          'Paper Capacity': '250 sheets',
          'Duty Cycle': '80,000 pages/month',
        },
        isTrending: true,
        rating: 4.5,
        reviewCount: 1250,
      ),
      Product(
        id: '2',
        name: 'Canon PIXMA TR4720',
        description: 'All-in-one wireless inkjet printer with scanning and copying',
        price: 89.99,
        images: [
          'https://images.unsplash.com/photo-1589330694653-ded6df03f754?w=500',
          'https://images.unsplash.com/photo-1541410965313-d53b3c16ef17?w=500',
        ],
        category: 'Inkjet',
        brand: 'Canon',
        specifications: {
          'Print Speed': '8.8 ipm (black), 4.4 ipm (color)',
          'Resolution': '4800 x 1200 dpi',
          'Connectivity': 'Wi-Fi, USB',
          'Paper Capacity': '100 sheets',
          'Functions': 'Print, Copy, Scan, Fax',
        },
        isTrending: true,
        rating: 4.2,
        reviewCount: 890,
      ),
      Product(
        id: '3',
        name: 'Epson EcoTank ET-2850',
        description: 'Cartridge-free printing with easy-to-fill supersized ink tanks',
        price: 249.99,
        images: [
          'https://images.unsplash.com/photo-1612198188060-c7c2a3b66eae?w=500',
          'https://images.unsplash.com/photo-1589330694653-ded6df03f754?w=500',
        ],
        category: 'Inkjet',
        brand: 'Epson',
        specifications: {
          'Print Speed': '10 ppm (black), 5 ppm (color)',
          'Resolution': '5760 x 1440 dpi',
          'Connectivity': 'Wi-Fi, USB',
          'Paper Capacity': '100 sheets',
          'Yield': 'Up to 4,500 pages (black), 7,500 pages (color)',
        },
        isTrending: false,
        rating: 4.7,
        reviewCount: 2100,
      ),
      Product(
        id: '4',
        name: 'Brother HL-L2350DW',
        description: 'Compact monochrome laser printer with wireless connectivity',
        price: 119.99,
        images: [
          'https://images.unsplash.com/photo-1541410965313-d53b3c16ef17?w=500',
          'https://images.unsplash.com/photo-1612198188060-c7c2a3b66eae?w=500',
        ],
        category: 'Laser',
        brand: 'Brother',
        specifications: {
          'Print Speed': '32 ppm',
          'Resolution': '2400 x 600 dpi',
          'Connectivity': 'Wi-Fi, USB',
          'Paper Capacity': '250 sheets',
          'Duplex': 'Automatic two-sided printing',
        },
        isTrending: true,
        rating: 4.4,
        reviewCount: 756,
      ),
      Product(
        id: '5',
        name: 'HP OfficeJet Pro 9015e',
        description: 'All-in-one wireless color inkjet printer for business',
        price: 179.99,
        images: [
          'https://images.unsplash.com/photo-1589330694653-ded6df03f754?w=500',
          'https://images.unsplash.com/photo-1541410965313-d53b3c16ef17?w=500',
        ],
        category: 'Inkjet',
        brand: 'HP',
        specifications: {
          'Print Speed': '22 ppm (black), 18 ppm (color)',
          'Resolution': '4800 x 1200 dpi',
          'Connectivity': 'Wi-Fi, Ethernet, USB',
          'Paper Capacity': '225 sheets',
          'Functions': 'Print, Copy, Scan, Fax',
        },
        isTrending: false,
        rating: 4.3,
        reviewCount: 1456,
      ),
      Product(
        id: '6',
        name: 'Canon imageCLASS MF445dw',
        description: 'Monochrome laser all-in-one with advanced security features',
        price: 329.99,
        images: [
          'https://images.unsplash.com/photo-1612198188060-c7c2a3b66eae?w=500',
          'https://images.unsplash.com/photo-1589330694653-ded6df03f754?w=500',
        ],
        category: 'Laser',
        brand: 'Canon',
        specifications: {
          'Print Speed': '40 ppm',
          'Resolution': '600 x 600 dpi',
          'Connectivity': 'Wi-Fi, Ethernet, USB',
          'Paper Capacity': '300 sheets',
          'Functions': 'Print, Copy, Scan, Fax',
        },
        isTrending: false,
        rating: 4.6,
        reviewCount: 643,
      ),
    ];
  }

  static User getCurrentUser() {
    return User(
      id: '1',
      name: 'John Doe',
      email: 'john.doe@example.com',
      phone: '+1 234 567 8900',
      orderHistory: [
        Order(
          id: '1',
          orderNumber: 'LJ-2024-001',
          date: DateTime.now().subtract(const Duration(days: 5)),
          status: 'Delivered',
          totalAmount: 229.99,
          productIds: ['1'],
        ),
        Order(
          id: '2',
          orderNumber: 'LJ-2024-002',
          date: DateTime.now().subtract(const Duration(days: 15)),
          status: 'Processing',
          totalAmount: 179.99,
          productIds: ['5'],
        ),
      ],
    );
  }

  static List<String> getCategories() {
    return ['All', 'Laser', 'Inkjet', 'Portable'];
  }

  static List<String> getBrands() {
    return ['All', 'HP', 'Canon', 'Epson', 'Brother'];
  }
}