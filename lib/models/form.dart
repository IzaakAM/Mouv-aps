class UserForm {
  int age = 0;
  String sex = ""; // Female, male, non-binary
  int height = 0; // In cm
  int weight = 0; // In kg
  List<String> disabilities = [];
  String family = ""; // Family details or status
  bool pregnant = false;
  int floors = 0;
  bool stairs = false;
  String job = "";
  List<String> medicalHistory = [];
  List<String> riskFactors = [];
  List<String> medicalCare = [];
  List<String> treatment = [];
  List<String> previousPhysicalActivity = [];
  List<String> currentPhysicalActivity = [];
  int physicalActivityFrequency = 0; // x times per week
  int physicalActivityDuration = 0; // In hours
  String physicalActivityIntensity = ""; // Low, moderate, high
  List<String> difficulties = [];
  bool canGetUp = false;
  bool sportsEquipment = false;
  String sportExpectations = "";
  String diet = "";
  List<String> foodAllergies = [];
  List<String> dislikedFoods = [];
  String foodExpectations = "";

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'age': age,
      'sex': sex,
      'height': height,
      'weight': weight,
      'disabilities': disabilities,
      'family': family,
      'pregnant': pregnant,
      'floors': floors,
      'stairs': stairs,
      'job': job,
      'medical_history': medicalHistory,
      'risk_factors': riskFactors,
      'medical_care': medicalCare,
      'treatment': treatment,
      'previous_physical_activity': previousPhysicalActivity,
      'current_physical_activity': currentPhysicalActivity,
      'physical_activity_frequency': physicalActivityFrequency,
      'physical_activity_duration': physicalActivityDuration,
      'physical_activity_intensity': physicalActivityIntensity,
      'difficulties': difficulties,
      'can_get_up': canGetUp,
      'sports_equipment': sportsEquipment,
      'sport_expectations': sportExpectations,
      'diet': diet,
      'food_allergies': foodAllergies,
      'disliked_foods': dislikedFoods,
      'food_expectations': foodExpectations,
    };
  }
}
