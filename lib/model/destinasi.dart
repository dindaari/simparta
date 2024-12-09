class Obyek {
  final String obyekId;
  final String obyekJenis;
  final String obyekNama;
  final String obyekDeskripsi;
  final String obyekAlamat;
  final String obyekFile;

  Obyek({
    required this.obyekId,
    required this.obyekJenis,
    required this.obyekNama,
    required this.obyekDeskripsi,
    required this.obyekAlamat,
    required this.obyekFile,
  });

  factory Obyek.fromJson(Map<String, dynamic> json) {
    return Obyek(
      obyekId: json['obyek_id'],
      obyekJenis: json['obyek_jenis'],
      obyekNama: json['obyek_nama'],
      obyekDeskripsi: json['obyek_deskripsi'],
      obyekAlamat: json['obyek_alamat'],
      obyekFile: json['obyek_file'],
    );
  }
}
