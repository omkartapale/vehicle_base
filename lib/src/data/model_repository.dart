import '../model/model.dart';

class ModelRepository {
  static const _allModels = <Model>[
    Model(id: '1', make: 'Maruti Suzuki', model: 'Omni'),
    Model(id: '2', make: 'Maruti Suzuki', model: 'Alto 800'),
    Model(id: '3', make: 'Honda', model: 'Civic'),
    Model(id: '4', make: 'Hyundai', model: 'Santro'),
    Model(id: '5', make: 'Toyota', model: 'Etios Liva'),
    Model(id: '6', make: 'Tata', model: 'Altroz'),
    Model(id: '7', make: 'Maruti Suzuki', model: 'Baleno'),
    Model(id: '8', make: 'Renault', model: 'Kwid'),
    Model(id: '9', make: 'Ford', model: 'Fiesta'),
    Model(id: '10', make: 'Datsun', model: 'GO'),
    Model(id: '11', make: 'Opel', model: 'Corsa'),
    Model(id: '12', make: 'Ford', model: 'Endavour'),
  ];

  static List<Model> loadAllModels() => _allModels;
}
