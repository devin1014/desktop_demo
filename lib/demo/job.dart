///剑士	10	11	12	13	14	15	16	17	10000	10000	10000	10000	100	50	10	600
class JobAncestry {
  final String name;
  final String id;
  final String rank1;
  final String rank2;
  final String rank3;
  final String rank4;
  final String rank5;
  final String rank6;
  final String rank7;
  final String _data;

  JobAncestry(
    this.name,
    this.id,
    this.rank1,
    this.rank2,
    this.rank3,
    this.rank4,
    this.rank5,
    this.rank6,
    this.rank7,
    this._data,
  );

  factory JobAncestry.builder(String data) {
    List<String> list = data.split("\t");
    return JobAncestry(
      list[0],
      list[1],
      list[2],
      list[3],
      list[4],
      list[5],
      list[6],
      list[7],
      list[8],
      data,
    );
  }

  @override
  String toString() => "${runtimeType.toString()}: $_data";
}

class Job {
  final String name;
  final String id;
  final String type;

  final String promoteMoney;
  final String promotePrestige;
  final String promoteSkill1;
  final String promoteSkill2;
  final String promoteSkill3;
  final String promoteSkill4;
  final String promoteSkill5;

  final String equipmentJian;
  final String equipmentFu;
  final String equipmentQiang;
  final String equipmentZhang;
  final String equipmentGong;
  final String equipmentXiaoDao;
  final String equipmentHuiLi;
  final String equipmentDun;
  final String equipmentTouKui;
  final String equipmentMaoZi;
  final String equipmentKaiJia;
  final String equipmentYiFu;
  final String equipmentPao;
  final String equipmentXueZi;
  final String equipmentXieZi;

  final String equipmentJewelry1;
  final String equipmentJewelry2;
  final String equipmentJewelry3;
  final String equipmentJewelry4;
  final String equipmentJewelry5;
  final String equipmentJewelry6;
  final String equipmentJewelry7;
  final String equipmentJewelry8;

  final String promoteSkill1Limit;
  final String promoteSkill2Limit;
  final String promoteSkill3Limit;
  final String promoteSkill4Limit;
  final String promoteSkill5Limit;

  final String _data;

  Job(
    this.name,
    this.id,
    this.type,
    this.promoteMoney,
    this.promotePrestige,
    this.promoteSkill1,
    this.promoteSkill2,
    this.promoteSkill3,
    this.promoteSkill4,
    this.promoteSkill5,
    this.equipmentJian,
    this.equipmentFu,
    this.equipmentQiang,
    this.equipmentZhang,
    this.equipmentGong,
    this.equipmentXiaoDao,
    this.equipmentHuiLi,
    this.equipmentDun,
    this.equipmentTouKui,
    this.equipmentMaoZi,
    this.equipmentKaiJia,
    this.equipmentYiFu,
    this.equipmentPao,
    this.equipmentXueZi,
    this.equipmentXieZi,
    this.equipmentJewelry1,
    this.equipmentJewelry2,
    this.equipmentJewelry3,
    this.equipmentJewelry4,
    this.equipmentJewelry5,
    this.equipmentJewelry6,
    this.equipmentJewelry7,
    this.equipmentJewelry8,
    this.promoteSkill1Limit,
    this.promoteSkill2Limit,
    this.promoteSkill3Limit,
    this.promoteSkill4Limit,
    this.promoteSkill5Limit,
    this._data,
  );

  factory Job.builder(String data) {
    List<String> list = data.split("\t");
    return Job(
      list[0],
      list[2],
      list[3],
      list[4],
      list[5],
      list[6],
      list[7],
      list[8],
      list[9],
      list[10],
      list[11],
      list[12],
      list[13],
      list[14],
      list[15],
      list[16],
      list[17],
      list[18],
      list[19],
      list[20],
      list[22],
      list[22],
      list[23],
      list[24],
      list[25],
      list[26],
      list[27],
      list[28],
      list[29],
      list[30],
      list[31],
      list[32],
      list[33],
      list[34],
      list[35],
      list[36],
      list[37],
      list[38],
      data,
    );
  }

  @override
  String toString() => "${runtimeType.toString()}: $_data";
}
