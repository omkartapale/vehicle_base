import '../model/vehicle.dart';

class VehicleRepository {
  static const _allVehicles = <Vehicle>[
    Vehicle(id: '1', make: 'Maruti Suzuki', model: 'Omni', variant: 'LXI'),
    Vehicle(id: '2', make: 'Maruti Suzuki', model: 'Alto 800', variant: 'LXI'),
    Vehicle(id: '3', make: 'Honda', model: 'Civic', variant: '1.6'),
    Vehicle(id: '4', make: 'Hyundai', model: 'Santro', variant: 'Xing'),
    Vehicle(id: '5', make: 'Toyota', model: 'Etios Liva', variant: 'G'),
    Vehicle(id: '6', make: 'Tata', model: 'Altroz', variant: 'XS'),
    Vehicle(id: '7', make: 'Maruti Suzuki', model: 'Baleno', variant: 'ZXI'),
    Vehicle(id: '8', make: 'Renault', model: 'Kwid', variant: '800'),
    Vehicle(id: '9', make: 'Ford', model: 'Fiesta'),
    Vehicle(id: '10', make: 'Datsun', model: 'GO'),
    Vehicle(id: '11', make: 'Opel', model: 'Corsa'),
    Vehicle(id: '12', make: 'Ford', model: 'Endavour', variant: 'High'),
  ];

  static List<Vehicle> loadAllVehicles() => _allVehicles;
}
