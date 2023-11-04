import '../model/make.dart';

class MakeRepository {
  static const _allMakers = <Make>[
    Make(id: '1', name: 'Maruti Suzuki'),
    Make(id: '2', name: 'Honda'),
    Make(id: '3', name: 'Hyundai'),
    Make(id: '4', name: 'Toyota'),
    Make(id: '5', name: 'Tata'),
    Make(id: '6', name: 'Renault'),
    Make(id: '7', name: 'Ford'),
    Make(id: '8', name: 'Datsun'),
    Make(id: '9', name: 'Opel'),
  ];

  static List<Make> loadAllMake() => _allMakers;
}
