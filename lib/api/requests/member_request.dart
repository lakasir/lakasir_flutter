class MemberRequest {
  final String? name;
  final String? address;
  final String? code;
  final String? email;

  MemberRequest({
    this.name,
    this.address,
    this.code,
    this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
      'code': code,
      'email': email,
    };
  }

  String? toQuery() {
    final query = <String>[];
    if (name != null) {
      query.add('filter[name]=$name');
    }
    if (address != null) {
      query.add('filter[address]=$address');
    }
    if (code != null) {
      query.add('filter[code]=$code');
    }
    if (email != null) {
      query.add('filter[email]=$email');
    }
    
    return query.join('&');
  }
}

