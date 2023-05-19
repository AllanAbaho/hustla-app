// To parse this JSON data, do
//
//     final JobResponse = JobResponseFromJson(jsonString);
//https://app.quicktype.io/
import 'dart:convert';

import 'package:hustla/data_model/login_response.dart';

JobResponse jobResponseFromJson(String str) =>
    JobResponse.fromJson(json.decode(str));

String jobResponseToJson(JobResponse data) => json.encode(data.toJson());

class JobResponse {
  JobResponse({
    this.jobs,
    this.status,
  });

  List<Job> jobs;
  bool status;

  factory JobResponse.fromJson(Map<String, dynamic> json) => JobResponse(
        jobs: List<Job>.from(json["jobs"].map((x) => Job.fromJson(x))),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "jobs": List<dynamic>.from(jobs.map((x) => x.toJson())),
        "status": status,
      };
}

class Job {
  Job({
    this.id,
    this.name,
    this.price,
    this.duration,
    this.location,
    this.type,
    this.description,
    this.deadline,
    this.category,
    this.status,
    this.applications,
  });

  int id;
  String name;
  String price;
  String duration;
  String location;
  String type;
  String description;
  String deadline;
  String category;
  String status;
  List<JobApplication> applications;

  factory Job.fromJson(Map<String, dynamic> json) => Job(
        id: json["id"],
        name: json["name"],
        price: json["price"],
        duration: json["duration"],
        location: json["location"],
        type: json["type"],
        description: json["description"],
        deadline: json["deadline"],
        category: json["category"],
        status: json["status"],
        applications: List<JobApplication>.from(
            json["applications"].map((x) => JobApplication.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price": price,
        "duration": duration,
        "location": location,
        "type": type,
        "description": description,
        "deadline": deadline,
        "category": category,
        "status": status,
        "applications": List<dynamic>.from(applications.map((x) => x.toJson())),
      };
}

class JobApplication {
  JobApplication({
    this.id,
    this.status,
    this.portfolio,
    this.user,
  });

  int id;
  String status;
  String portfolio;
  User user;

  factory JobApplication.fromJson(Map<String, dynamic> json) => JobApplication(
        id: json["id"],
        status: json["status"],
        portfolio: json["portfolio"],
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "status": status,
        "portfolio": portfolio,
        "user": user.toJson(),
      };
}
