import '../model/make.dart';

class MakeRepository {
  static const _allMakers = <Make>[
    Make(id: '1', name: 'Maruti Suzuki', lowercasedName: 'maruti suzuki'),
    Make(id: '2', name: 'Honda', lowercasedName: 'honda'),
    Make(id: '3', name: 'Hyundai', lowercasedName: 'hyundai'),
    Make(id: '4', name: 'Toyota', lowercasedName: 'toyota'),
    Make(id: '5', name: 'Tata', lowercasedName: 'tata'),
    Make(id: '6', name: 'Renault', lowercasedName: 'renault'),
    Make(id: '7', name: 'Ford', lowercasedName: 'ford'),
    Make(id: '8', name: 'Datsun', lowercasedName: 'datsun'),
    Make(id: '9', name: 'Opel', lowercasedName: 'opel'),
  ];

  static List<Make> loadAllMake() => _allMakers;
}
