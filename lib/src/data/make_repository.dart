import '../model/make.dart';

class MakeRepository {
  static const _allMakers = <Make>[
    Make(id: '1', make: 'Maruti Suzuki'),
    Make(id: '2', make: 'Honda'),
    Make(id: '3', make: 'Hyundai'),
    Make(id: '4', make: 'Toyota'),
    Make(id: '5', make: 'Tata'),
    Make(id: '6', make: 'Renault'),
    Make(id: '7', make: 'Ford'),
    Make(id: '8', make: 'Datsun'),
    Make(id: '9', make: 'Opel'),
    Make(id: '10', make: 'Ford'),
  ];

  static List<Make> loadAllMake() => _allMakers;
}
