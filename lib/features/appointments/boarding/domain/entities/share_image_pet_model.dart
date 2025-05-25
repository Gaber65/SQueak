class ShareImagePetModel {
  String image;
  String petId;
  String petSqueakId;
  String petName;
  String description;

  ShareImagePetModel({
    required this.image,
    required this.petId,
    required this.petSqueakId,
    required this.petName,
    required this.description,
  });

  factory ShareImagePetModel.fromJson(Map<String, dynamic> json) {
    return ShareImagePetModel(
      image: json['image'] ?? '',
      petId: json['petId'] ?? '',
      petSqueakId: json['petSqueakId'] ?? '',
      petName: json['petName'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image'] = image;
    data['petId'] = petId;
    data['petSqueakId'] = petSqueakId;
    data['petName'] = petName;
    data['description'] = description;
    return data;
  }

  static List<ShareImagePetModel> dummyShareImagePetModels = [
    ShareImagePetModel(
      image:
          'https://img.freepik.com/free-photo/washing-pet-dog-home_23-2149627217.jpg?t=st=1728301483~exp=1728305083~hmac=d0e5d37fe0dfef76fa3d7d7b3aa36dad66a56e2b992dde189f29710e7966534f&w=1380',
      petId: 'PET001',
      petSqueakId: 'SQK001',
      petName: 'Buddy',
      description:
          'Buddy is an energetic golden retriever who loves playing fetch.',
    ),
    ShareImagePetModel(
      image:
          'https://img.freepik.com/free-photo/washing-pet-dog-home_23-2149627257.jpg?t=st=1728301614~exp=1728305214~hmac=5219946da1534fa34cd336c52d23693e3a964dea2003bd4d64970690e6ade9cf&w=1380',
      petId: 'PET002',
      petSqueakId: 'SQK002',
      petName: 'Luna',
      description: 'Luna is a gentle cat who enjoys sunbathing by the window.',
    ),
    ShareImagePetModel(
      image:
          'https://img.freepik.com/free-photo/woman-shears-dog-dog-sitting-couch-breed-yorkshire-terrier_1157-46558.jpg?t=st=1728301646~exp=1728305246~hmac=47ad117b9ae868b3ef367b4e6360f1f07ab994dba64c762d8ce96e43d240d324&w=1380',
      petId: 'PET003',
      petSqueakId: 'SQK003',
      petName: 'Charlie',
      description:
          'Charlie is a playful beagle with a love for adventures in the park.',
    ),
    ShareImagePetModel(
      image:
          'https://img.freepik.com/free-photo/brushing-teeth-process-small-dog-sits-table-dog-brushed-by-professional_1157-48823.jpg?t=st=1728301678~exp=1728305278~hmac=adc658e1ea102529a28ecbb5387f63a4bc87a304647d6c6755eae982c995164a&w=1380',
      petId: 'PET004',
      petSqueakId: 'SQK004',
      petName: 'Max',
      description: 'Max is a curious tabby cat who loves exploring new places.',
    ),
  ];
}
