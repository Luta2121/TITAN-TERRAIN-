extends Node3D

const CAR = preload("res://scripts/car.gd")
var car
var cam
var hud

func h(x,z):
    return 0.65*sin(z*0.07)+0.28*sin(z*0.18+x*0.5)

func mat(c):
    var m=StandardMaterial3D.new()
    m.albedo_color=c
    m.roughness=0.9
    return m

func _ready():
    var sun=DirectionalLight3D.new()
    sun.rotation_degrees=Vector3(-48,-28,0)
    sun.shadow_enabled=true
    add_child(sun)

    var env=WorldEnvironment.new()
    var e=Environment.new()
    e.background_mode=Environment.BG_SKY
    e.ambient_light_source=Environment.AMBIENT_SOURCE_SKY
    env.environment=e
    add_child(env)

    make_terrain()

    car=RigidBody3D.new()
    car.set_script(CAR)
    car.position=Vector3(0,3,0)
    add_child(car)

    cam=Camera3D.new()
    cam.current=true
    add_child(cam)

func make_terrain():
    var st=SurfaceTool.new()
    st.begin(Mesh.PRIMITIVE_TRIANGLES)

    for z in range(150):
        for x in range(30):
            var a=Vector3(x-15,h(x-15,z),-z)
            var b=Vector3(x-14,h(x-14,z),-z)
            var c=Vector3(x-14,h(x-14,z+1),-z-1)
            var d=Vector3(x-15,h(x-15,z+1),-z-1)
            st.add_vertex(a)
            st.add_vertex(c)
            st.add_vertex(b)
            st.add_vertex(a)
            st.add_vertex(d)
            st.add_vertex(c)

    st.generate_normals()
    var mesh=st.commit()
    var ground=MeshInstance3D.new()
    ground.mesh=mesh
    ground.material_override=mat(Color(0.25,0.4,0.2))
    add_child(ground)

func _process(delta):
    if car:
        cam.global_position=cam.global_position.lerp(
            car.global_position+Vector3(0,4,9),delta*3)
        cam.look_at(car.global_position)
