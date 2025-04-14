# 07. Relational Database

[Previous](/06.%20CRUD%20Local%20Database/) | [Main Page](/) | [Next](/07.%20Awesome%20Notifications/)

## Content Outline

- [One-to-one](#one-to-one-relationship)
- [One-to-many](#one-to-many-relationship)
- [Many-to-many](#many-to-many-relationship)

This module covers relationship between two objects in database Isar.

## One-to-one relationship

In a one-to-one relationship, one object in a collection is related to only one object in another collection and vice versa. In example, a `User` has one `Profile`, and each `Profile` belongs to one `User`.

To model this, we use `IsarLink<T>` type to link between two classes.

```dart
@Collection()
class User {
  Id id = Isar.autoIncrement;

  late String name;

  // One-to-one link to Profile
  final profile = IsarLink<Profile>();
}

@Collection()
class Profile {
  Id id = Isar.autoIncrement;

  late String bio;
  late String avatarUrl;
}
```

`User` has a profile property of type `IsarLink<Profile>()`.

Here is the example how to use this relationship

```dart
// Create object relation
final user = User()..name = 'Alice';
final profile = Profile()
  ..bio = 'Hello!'
  ..avatarUrl = 'https://image.url';

// Link them together
user.profile.value = profile;

await isar.writeTxn(() async {
  await isar.profiles.put(profile); // save the profile first
  await isar.users.put(user); // then save the user
});
```

```dart
// How to access the linked profile
final loadedUser = await isar.users.get(user.id);

// Load the linked profile
await loadedUser!.profile.load();

print(loadedUser.profile.value?.bio); // Output: Hello!

```

```dart
// How to remove the link
user.profile.value = null;

await isar.writeTxn(() async {
  await isar.users.put(user); // Update the link
});
```

## One-to-many relationship

In a one-to-many relationship, one object in a collection is related to many one object in another collection. In example, a `User` can have many `Post`s, but each `Post` belongs to one `User`.

In Isar, One-to-Many is modeled using a reverse link from the “many” side with `IsarLink<T>`.

```dart
@Collection()
class User {
  Id id = Isar.autoIncrement;

  late String name;
  // No need to explicitly define the one-to-many here
}

@Collection()
class Post {
  Id id = Isar.autoIncrement;

  late String title;
  late String content;

  final user = IsarLink<User>(); // Many-to-One link
}

```

Here is the example how to use this relationship

```dart
// Create object relation
final user = User()..name = 'Alice';

final post1 = Post()
  ..title = 'My First Post'
  ..content = 'Hello world!'
  ..user.value = user;

final post2 = Post()
  ..title = 'Another Post'
  ..content = 'More content here'
  ..user.value = user;

await isar.writeTxn(() async {
  await isar.users.put(user); // Save the user first
  await isar.posts.putAll([post1, post2]); // Then the posts
});

```

```dart
// Get all posts for a user

final userId = user.id;

final posts = await isar.posts
    .filter()
    .user((q) => q.idEqualTo(userId))
    .findAll();

for (final post in posts) {
  print(post.title);
}
```

### Many-to-many relationship

In a many-to-many relationship, many object in a collection is related to many one object in another collection. In example, a `Student` can enroll to many `Course`s, and a `Course` can have many `Student`s.

In Isar, you use `IsarLinks<T>` on both sides of the relationship.

```dart
@Collection()
class Student {
  Id id = Isar.autoIncrement;

  late String name;

  final courses = IsarLinks<Course>(); // Many-to-Many
}

@Collection()
class Course {
  Id id = Isar.autoIncrement;

  late String title;

  final students = IsarLinks<Student>(); // Many-to-Many
}

```

Here is the example how to use this relationship

```dart
final math = Course()..title = 'Math';
final science = Course()..title = 'Science';

final alice = Student()..name = 'Alice';
final bob = Student()..name = 'Bob';

// Link students to courses
alice.courses.addAll([math, science]);
bob.courses.add(math);

// Link courses to students (optional but recommended for bi-directional access)
math.students.addAll([alice, bob]);
science.students.add(alice);

await isar.writeTxn(() async {
  await isar.courses.putAll([math, science]);
  await isar.students.putAll([alice, bob]);

  // Save the links
  await alice.courses.save();
  await bob.courses.save();
  await math.students.save();
  await science.students.save();
});

```
