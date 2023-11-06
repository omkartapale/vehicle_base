import '../model/model.dart';

class ModelRepository {
  static const _allModels = <Model>[
    Model(id: '1', make: 'Maruti Suzuki', name: 'Omni'),
    Model(id: '2', make: 'Maruti Suzuki', name: 'Alto 800'),
    Model(id: '3', make: 'Honda', name: 'Civic'),
    Model(id: '4', make: 'Hyundai', name: 'Santro'),
    Model(id: '5', make: 'Toyota', name: 'Etios Liva'),
    Model(id: '6', make: 'Tata', name: 'Altroz'),
    Model(id: '7', make: 'Maruti Suzuki', name: 'Baleno'),
    Model(id: '8', make: 'Renault', name: 'Kwid'),
    Model(id: '9', make: 'Ford', name: 'Fiesta'),
    Model(id: '10', make: 'Datsun', name: 'GO'),
    Model(id: '11', make: 'Opel', name: 'Corsa'),
    Model(id: '12', make: 'Ford', name: 'Endavour'),
  ];

  static List<Model> loadAllModels() => _allModels;

  static List<Model> filterModels(String make) {
    return _allModels.where((Model model) {
      return model.make == make;
    }).toList();
  }
}
