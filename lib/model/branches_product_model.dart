class BranchesProductModel {
  String branchId; 

  String pName;
  String pQuantity;
  String pPrice;

  BranchesProductModel({
    required this.branchId, 
    
    required this.pName,
    required this.pQuantity,
    required this.pPrice,
  });

  factory BranchesProductModel.fromJson(Map<String, dynamic> json) {
    return BranchesProductModel(
      branchId: json['branch'], 
      
      pName: json['p_name'],
      pQuantity: json['p_quantity'],
      pPrice: json['p_price'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'branch': branchId, 
      
      'p_name': pName,
      'p_quantity': pQuantity,
      'price': pPrice,
    };
  }
}