
extends RigidBody3D

var gas = false
var brake = false
var steer = 0.0

func material(col):
    var m = StandardMaterial3D.new()
    m.albedo_color = col
    return m

func _ready():
    mass = 1050
    linear_damp = 0.08
    angular_damp = 1.5

    var body = MeshInstance3D.new()
    var box = BoxMesh.new()
    box.size = Vector3(1.9, 0.7, 3.3)
    body.mesh = box
    body.position.y = 0.85
    body.material_override = material(Color(0.8, 0.12, 0.04))
    add_child(body)

    var cabin = MeshInstance3D.new()
    var cab = BoxMesh.new()
    cab.size = Vector3(1.45, 0.8, 1.6)
    cabin.mesh = cab
    cabin.position = Vector3(0, 1.5, -0.3)
    cabin.material_override = material(Color(0.1, 0.2, 0.3))
    add_child(cabin)

    var collision = CollisionShape3D.new()
    var shape = BoxShape3D.new()
    shape.size = Vector3(1.8, 0.8, 3.1)
    collision.shape = shape
    collision.position.y = 0.85
    add_child(collision)

func _physics_process(delta):
    var forward = -global_transform.basis.z
    if gas:
        apply_central_force(forward * 9000)
    if brake:
        apply_central_force(-linear_velocity * 1800)
    apply_torque(Vector3.UP * steer * 1200)
