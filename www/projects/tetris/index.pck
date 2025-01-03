GDPC                �
                                                                      !   T   res://.godot/exported/133200997/export-2560527257bd42faa13afbc3e1dab95d-Tetris.scn  �C            ��
i/���Nh�UP2    X   res://.godot/exported/133200997/export-d2cdd72aeaa7d07fc03eff2e26d01ef4-TitleMenu.scn   �T      �
      w:�M���c�-�S    ,   res://.godot/global_script_class_cache.cfg  Pb      e      ��Vx�1���<B�gvy�    D   res://.godot/imported/blue.png-4d748ed6429caf8afc2e9d3803eadf6e.ctex        �       ��-���R� �:��    L   res://.godot/imported/downarrow.png-d9df94d6b779b2a29344490a7ee4ca36.ctex   �      �      =h{)���'d��<�    H   res://.godot/imported/empty.png-6cfed9f1c7a7361513986ce73b0d7afa.ctex   �      �       ���_ �"��b��MŻ    H   res://.godot/imported/green.png-5db815cc8219d4fb24db6968e2796f87.ctex   �      �       %�45m�}N�� �    D   res://.godot/imported/icon.svg-218a8f2b3041327d8a5756f3a245f83b.ctex�      \      6(4�d=EQ�ǮVj,    L   res://.godot/imported/leftarrow.png-26914c7b52567a506b490fcfa9bb52be.ctex   )      �      =v�P���2A� ��    D   res://.godot/imported/red.png-13f6abb0e0c70056504666ed9c349d99.ctex �5      �       ��K���ΕiE����    L   res://.godot/imported/rightarrow.png-3566e5534ffff183538c19ac04150398.ctex  p7      �      �l���X9���n�л�    L   res://.godot/imported/rotatearrow.png-28122ee25a229600adc97ee600531be2.ctex �9            ���>�����]�ۥ       res://.godot/uid_cache.bin  t      �      .�3vk�C�\�gq>�       res://ControlledPiece.gd�      1	      yܗ�t{�F���       res://Credits.gd�
      /      K����[���t>�       res://Grid.gd   �      T      �dZ=�m@�h�튔"�       res://Piece.gd  �+      9
      ���}��ޑG�D��K       res://Tetris.gd �<            .>�X;�T|I��A��7       res://Tetris.tscn.remap pa      c       d�v��f�K�8�y�ݱ       res://TitleMenu.gd   T      �       ��^ᜆ?��m~��       res://TitleMenu.tscn.remap  �a      f       7��h�>��v( ֑       res://UI.gd �_      �      *�z}4<y �[�Q����       res://blue.png.import   �       �       �}1X�E�XC�p��@       res://downarrow.png.import  �      �       D�Kb�p	R:Ti<b       res://empty.png.import        �       ���Ǎ��@�V�al(Y       res://green.png.import  �      �       �21�߲��l�ն�|��       res://icon.svg  �c      N      ]��s�9^w/�����       res://icon.svg.import   @(      �       �UX���}��7/!�}�h       res://leftarrow.png.import  �*      �       �y�>H�j���0       res://project.binary�u      	      ����|(��N�� ��       res://red.png.import�6      �       �	��9��S)���       res://rightarrow.png.import  9      �       }Hjmβ�4��G7 ��       res://rotatearrow.png.import <      �       ���ne�s�R)ԣ��    GST2              ����                          �   RIFF�   WEBPVP8Lt   /� g@�m�߁� ����$�������`T�-E� XE���~�
^'K�T̮(( �� yQpQ
Qw��nJ�Ң�+]J����J �J�R�Jd,7��ɫV�.[remap]

importer="texture"
type="CompressedTexture2D"
uid="uid://katljsb5vn25"
path="res://.godot/imported/blue.png-4d748ed6429caf8afc2e9d3803eadf6e.ctex"
metadata={
"vram_texture": false
}
 extends Piece

class_name ControlledPiece

@export_node_path("Grid") var grid_path: NodePath

signal piece_placed 
signal collision_on_entry

var grid: Grid

var last_pressed_left: int = -1
var last_pressed_right: int = -1

func _init(old_piece: Piece):
	if old_piece:
		shape_index = old_piece.shape_index
		color = old_piece.color

# Called when the node enters the scene tree for the first time.
func _ready():
	x = start_x
	y = start_y

	grid = get_node(grid_path)
	
	if _has_collision_with_offset(0, 0):
		placed = true
		collision_on_entry.emit()
	
	draw()

func _process(delta):
	if placed:
		return
	
	if !Input.is_action_pressed("Left"):
		last_pressed_left = -1
	
	if !Input.is_action_pressed("Right"):
		last_pressed_right = -1
	
	erase()
	
	if Input.is_action_just_pressed("Rotate"):
		var total_rotations = shapes[shape_index].size()
		rotation_index = (rotation_index + 1) % total_rotations
		
		if _has_collision_with_offset(0, 0):
			rotation_index = (rotation_index - 1 + total_rotations) % total_rotations
	
	var xoff = 0
	
	if Input.is_action_just_pressed("Left"):
		last_pressed_left = Time.get_ticks_msec()
		if !_has_collision_with_offset(-1, 0):
			xoff = -1
	
	if Input.is_action_just_pressed("Right"):
		last_pressed_right = Time.get_ticks_msec()
		if !_has_collision_with_offset(1, 0):
			xoff = 1
	
	x += xoff
	
	draw()

func _on_fast_tick():
	if placed:
		return

	if Input.is_action_pressed("Down"):
		_move_down()
	
	if placed:
		return

	erase()
	
	var xoff = 0
	
	if Input.is_action_pressed("Left") and \
			last_pressed_left > 0 and \
			Time.get_ticks_msec() > last_pressed_left + 500:
		if !_has_collision_with_offset(-1, 0):
			xoff = -1
	
	if Input.is_action_pressed("Right") and \
			last_pressed_right > 0 and \
			Time.get_ticks_msec() > last_pressed_right + 500:
		if !_has_collision_with_offset(1, 0):
			xoff = 1
	
	x += xoff
	
	draw()

func _on_game_tick():
	if placed:
		return

	if !Input.is_action_pressed("Down"):
		_move_down()

func _move_down():
	erase()
	
	var next_move_collides: bool = _has_collision_with_offset(0, 1)

	if not next_move_collides:
		y += 1
	
	draw()

	if next_move_collides:
		placed = true
		piece_placed.emit()

func _has_collision_with_offset(x: int, y: int) -> bool:
	for pos in _every_piece_pos():
		if !grid._is_space_empty(pos.x + x, pos.y + y):
			return true
	return false
               extends RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	var license_text = Engine.get_license_text()
	license_text += "\n\n\n"
	
	var license_info = Engine.get_license_info()
	var copyright_info = Engine.get_copyright_info()
	for key in copyright_info:
		if key["name"] in ["Mbed TLS", "ENet", "The FreeType Project"]:
			for part in key["parts"]:
				license_text += "Copyright {0}\n\n{1}\n\n\n".format([
					", ".join(part["copyright"]),
					license_info[part["license"]]
				])

	append_text(license_text)
 GST2              ����                          �  RIFFz  WEBPVP8Lm  /�p�6�$���C�{�Y�c�ֶ����Щ##�TX�D�uds�wC۶���m�H���ݫ�8�e\;�uc����O,|j2��⁕�1�L&�X�g������;��������:��s���k�ܼg�ow���Elq�>��㿺s���Ň~�7,\n.����/bK�.����d�_s�0�]>�/��M�ͺm�+�F?��w�æ���W�̫�»Vf��Ýf��+�aY����aX����^���wS�F2�e�(|f�?��Qs��L�|b�ѳ�/>�r�O�i�1g��n�cf�2��'��2z=W�s��i0|hY~߻d���#�2���뇭�0\�8��y        [remap]

importer="texture"
type="CompressedTexture2D"
uid="uid://duqtvmbisc3a2"
path="res://.godot/imported/downarrow.png-d9df94d6b779b2a29344490a7ee4ca36.ctex"
metadata={
"vram_texture": false
}
           GST2              ����                          T   RIFFL   WEBPVP8L?   /� �+��+� PU�6t頏Cqfr��"�?8��6I���%�w�1�R�L�Q��E     [remap]

importer="texture"
type="CompressedTexture2D"
uid="uid://cjuk6tvsvcr37"
path="res://.godot/imported/empty.png-6cfed9f1c7a7361513986ce73b0d7afa.ctex"
metadata={
"vram_texture": false
}
               GST2              ����                          �   RIFF�   WEBPVP8L�   /� w H�IO�mJ?�dۆ����C� AQ���*�$Ū�c2@vI�8K�ӓ��L��Y2��	 @]Uz�u;�p�Is/�F'�����i�e�O�@)��"PFcX�QJ�A+�A9k�Q��m_׆ [remap]

importer="texture"
type="CompressedTexture2D"
uid="uid://ckxue5srh8hot"
path="res://.godot/imported/green.png-5db815cc8219d4fb24db6968e2796f87.ctex"
metadata={
"vram_texture": false
}
               extends Node2D

class_name Grid

@export var width: int
@export var height: int

signal rows_cleared(num_rows: int)

@onready var color_textures = {
	"empty": load("res://empty.png"),
	"red": load("res://red.png"),
	"blue": load("res://blue.png"),
	"green": load("res://green.png"),
}

var grid: Array
var sprite_grid: Array
var IMAGE_WIDTH = 32

class GridElem:
	var filled: bool = false
	var color: String = "green"

# Called when the node enters the scene tree for the first time.
func _ready():
	grid = []
	for i in range(width * height):
		grid.append(GridElem.new())
	
	for i in range(width):
		for j in range(height):
			var sprite = Sprite2D.new()
			sprite.texture = color_textures["empty"]
			sprite.position.x = IMAGE_WIDTH * i + IMAGE_WIDTH / 2
			sprite.position.y = IMAGE_WIDTH * j + IMAGE_WIDTH / 2
			sprite_grid.append(sprite)
			add_child(sprite)

func _process(delta):
	for i in range(width):
		for j in range(height):
			var elem = _get_elem_at(i, j)
			if elem.filled:
				_set_texture_at(i, j, elem.color)
			else:
				_set_texture_at(i, j, "empty")

func _set_texture_at(x: int, y: int, texture: String):
	sprite_grid[x * height + y].texture = color_textures[texture]

func _get_elem_at(x: int, y: int) -> GridElem:
	return grid[y * width + x]

func _set_elem_at(x: int, y: int, elem: GridElem):
	grid[y * width + x] = elem

func _is_space_empty(x: int, y: int) -> bool:
	if y >= height:
		return false
	
	if x < 0 or x >= width:
		return false
	
	var elem = _get_elem_at(x, y)
	return !elem.filled

func _on_piece_position_updated(x, y, filled, color):
	var new_elem = GridElem.new()
	new_elem.filled = filled
	new_elem.color = color
	_set_elem_at(x, y, new_elem)

func _on_piece_placed():
	var num_rows = 0
	
	for row in range(height):
		var is_full = true
		for col in range(width):
			if _is_space_empty(col, row):
				is_full = false
				break
		
		if is_full:
			num_rows += 1
			for rrow in range(row - 1, -1, -1):
				for col in range(width):
					_set_elem_at(col, rrow + 1, _get_elem_at(col, rrow))
			for col in range(width):
				_set_elem_at(col, 0, GridElem.new())
	
	rows_cleared.emit(num_rows)
            GST2   �   �      ����               � �        $  RIFF  WEBPVP8L  /������!"2�H�l�m�l�H�Q/H^��޷������d��g�(9�$E�Z��ߓ���'3���ض�U�j��$�՜ʝI۶c��3� [���5v�ɶ�=�Ԯ�m���mG�����j�m�m�_�XV����r*snZ'eS�����]n�w�Z:G9�>B�m�It��R#�^�6��($Ɓm+q�h��6�5��I��'���F�"ɹ{�p����	"+d������M�q��� .^>и��6��a�q��gD�h:L��A�\D�
�\=k�(���_d2W��dV#w�o�	����I]�q5�*$8Ѡ$G9��lH]��c�LX���ZӞ3֌����r�2�2ؽL��d��l��1�.��u�5�!�]2�E��`+�H&�T�D�ި7P��&I�<�ng5�O!��͙������n�
ؚѠ:��W��J�+�����6��ɒ�HD�S�z�����8�&�kF�j7N�;YK�$R�����]�VٶHm���)�rh+���ɮ�d�Q��
����]	SU�9�B��fQm]��~Z�x.�/��2q���R���,snV{�7c,���p�I�kSg�[cNP=��b���74pf��)w<:Ŋ��7j0���{4�R_��K܅1�����<߁����Vs)�j�c8���L�Um% �*m/�*+ �<����S��ɩ��a��?��F�w��"�`���BrV�����4�1�*��F^���IKJg`��MK������!iVem�9�IN3;#cL��n/�i����q+������trʈkJI-����R��H�O�ܕ����2
���1&���v�ֳ+Q4蝁U
���m�c�����v% J!��+��v%�M�Z��ꚺ���0N��Q2�9e�qä�U��ZL��䜁�u_(���I؛j+0Ɩ�Z��}�s*�]���Kܙ����SG��+�3p�Ei�,n&���>lgC���!qյ�(_e����2ic3iڦ�U��j�q�RsUi����)w��Rt�=c,if:2ɛ�1�6I�����^^UVx*e��1�8%��DzR1�R'u]Q�	�rs��]���"���lW���a7]o�����~P���W��lZ�+��>�j^c�+a��4���jDNὗ�-��8'n�?e��hҴ�iA�QH)J�R�D�̰oX?ؿ�i�#�?����g�к�@�e�=C{���&��ށ�+ڕ��|h\��'Ч_G�F��U^u2T��ӁQ%�e|���p ���������k	V����eq3���8 � �K�w|�Ɗ����oz-V���s ����"�H%* �	z��xl�4��u�"�Hk�L��P���i��������0�H!�g�Ɲ&��|bn�������]4�"}�"���9;K���s��"c. 8�6�&��N3R"p�pI}��*G��3@�`��ok}��9?"@<�����sv� ���Ԣ��Q@,�A��P8��2��B��r��X��3�= n$�^ ������<ܽ�r"�1 �^��i��a �(��~dp-V�rB�eB8��]
�p ZA$\3U�~B�O ��;��-|��
{�V��6���o��D��D0\R��k����8��!�I�-���-<��/<JhN��W�1���H�#2:E(*�H���{��>��&!��$| �~�\#��8�> �H??�	E#��VY���t7���> 6�"�&ZJ��p�C_j���	P:�a�G0 �J��$�M���@�Q��[z��i��~q�1?�E�p�������7i���<*�,b�е���Z����N-
��>/.�g�'R�e��K�)"}��K�U�ƹ�>��#�rw߶ȑqF�l�Ο�ͧ�e�3�[䴻o�L~���EN�N�U9�������w��G����B���t��~�����qk-ί�#��Ξ����κ���Z��u����;{�ȴ<������N�~���hA+�r ���/����~o�9>3.3�s������}^^�_�����8���S@s%��]K�\�)��B�w�Uc۽��X�ǧ�;M<*)�ȝ&����~$#%�q����������Q�4ytz�S]�Y9���ޡ$-5���.���S_��?�O/���]�7�;��L��Zb�����8���Guo�[''�،E%���;����#Ɲ&f��_1�߃fw�!E�BX���v��+�p�DjG��j�4�G�Wr����� 3�7��� ������(����"=�NY!<l��	mr�՚���Jk�mpga�;��\)6�*k�'b�;	�V^ݨ�mN�f�S���ն�a���ϡq�[f|#U����^����jO/���9͑Z��������.ɫ�/���������I�D��R�8�5��+��H4�N����J��l�'�כ�������H����%"��Z�� ����`"��̃��L���>ij~Z,qWXo�}{�y�i�G���sz�Q�?�����������lZdF?�]FXm�-r�m����Ф:�З���:}|x���>e������{�0���v��Gş�������u{�^��}hR���f�"����2�:=��)�X\[���Ů=�Qg��Y&�q�6-,P3�{�vI�}��f��}�~��r�r�k�8�{���υ����O�֌ӹ�/�>�}�t	��|���Úq&���ݟW����ᓟwk�9���c̊l��Ui�̸~��f��i���_�j�S-|��w�R�<Lծd�ٞ,9�8��I�Ү�6 *3�ey�[�Ԗ�k��R���<������
g�R���~��a��
��ʾiI9u����*ۏ�ü�<mԤ���T��Amf�B���ĝq��iS��4��yqm-w�j��̝qc�3�j�˝mqm]P��4���8i�d�u�΄ݿ���X���KG.�?l�<�����!��Z�V�\8��ʡ�@����mK�l���p0/$R�����X�	Z��B�]=Vq �R�bk�U�r�[�� ���d�9-�:g I<2�Oy�k���������H�8����Z�<t��A�i��#�ӧ0"�m�:X�1X���GҖ@n�I�겦�CM��@������G"f���A$�t�oyJ{θxOi�-7�F�n"�eS����=ɞ���A��Aq�V��e����↨�����U3�c�*�*44C��V�:4�ĳ%�xr2V�_)^�a]\dZEZ�C 
�*V#��	NP��\�(�4^sh8T�H��P�_��}�    [remap]

importer="texture"
type="CompressedTexture2D"
uid="uid://by7t063xewhpx"
path="res://.godot/imported/icon.svg-218a8f2b3041327d8a5756f3a245f83b.ctex"
metadata={
"vram_texture": false
}
                GST2              ����                          |  RIFFt  WEBPVP8Lg  /�`Զ����?��l����1Tm��I��`����| ��o��4k{����h۶���m�H�{{�+�4R3���X\k�7L&����>�5ӧm�c�i��C5�7�b�#��_��f%�%�/{�;��5w��a�=S�6�ԓ�^h�*��Vw��ǟ9�c�}8��%�{ܓ�t���Xc�EC�����i����_���~��O��h���E�Zjx���E��8���k����g��W��_�x���v1���8�s�a�g��w����D��S�wK�V�/�\���*�Z[�;�ԏN[Zb��U=o18`1c�϶W�aX��SE��&f��.������/=3v)c���-�W              [remap]

importer="texture"
type="CompressedTexture2D"
uid="uid://be2hko673l44p"
path="res://.godot/imported/leftarrow.png-26914c7b52567a506b490fcfa9bb52be.ctex"
metadata={
"vram_texture": false
}
           extends Node2D

class_name Piece

@export var start_x: int = 0
@export var start_y: int = 0

signal position_updated(x: int, y: int, filled: bool, color: String)

var O = true
var v = false

var shapes: Array = [
	[
		[
			[v, v, v],
			[O, O, O],
			[v, v, O],
		],
		[
			[v, O, v],
			[v, O, v],
			[O, O, v],
		],
		[
			[O, v, v],
			[O, O, O],
			[v, v, v],
		],
		[
			[v, O, O],
			[v, O, v],
			[v, O, v],
		],
	],
	[
		[
			[v, v, v],
			[O, O, O],
			[O, v, v],
		],
		[
			[O, O, v],
			[v, O, v],
			[v, O, v],
		],
		[
			[v, v, O],
			[O, O, O],
			[v, v, v],
		],
		[
			[v, O, v],
			[v, O, v],
			[v, O, O],
		],
	],
	[
		[
			[v, O, v, v],
			[v, O, v, v],
			[v, O, v, v],
			[v, O, v, v],
		],
		[
			[v, v, v, v],
			[O, O, O, O],
			[v, v, v, v],
			[v, v, v, v],
		],
		[
			[v, v, O, v],
			[v, v, O, v],
			[v, v, O, v],
			[v, v, O, v],
		],
		[
			[v, v, v, v],
			[v, v, v, v],
			[O, O, O, O],
			[v, v, v, v],
		],
	],
	[
		[
			[v, O, O, v],
			[v, O, O, v],
		],
	],
	[
		[
			[v, O, v],
			[O, O, v],
			[v, O, v],
		],
		[
			[v, O, v],
			[O, O, O],
			[v, v, v],
		],
		[
			[v, O, v],
			[v, O, O],
			[v, O, v],
		],
		[
			[v, v, v],
			[O, O, O],
			[v, O, v],
		],
	],
	[
		[
			[v, v, O],
			[v, O, O],
			[v, O, v],
		],
		[
			[v, v, v],
			[O, O, v],
			[v, O, O],
		],
		[
			[v, O, v],
			[O, O, v],
			[O, v, v],
		],
		[
			[O, O, v],
			[v, O, O],
			[v, v, v],
		],
	],
	[
		[
			[O, v, v],
			[O, O, v],
			[v, O, v],
		],
		[
			[v, O, O],
			[O, O, v],
			[v, v, v],
		],
		[
			[v, O, v],
			[v, O, O],
			[v, v, O],
		],
		[
			[v, v, v],
			[v, O, O],
			[O, O, v],
		],
	]
]

var all_colors = [
	"green",
	"red",
	"blue",
]

var color: String
var shape_index: int
var rotation_index: int = 0

var x: int
var y: int

var placed: bool = false

func _init():
	if shape_index != null:
		shape_index = randi_range(0, shapes.size() - 1)
	if color != null:
		color = all_colors[randi_range(0, all_colors.size() - 1)]

# Called when the node enters the scene tree for the first time.
func _ready():
	x = start_x
	y = start_y

	draw()

func erase():
	for pos in _every_piece_pos():
		position_updated.emit(pos.x, pos.y, false, color)

func draw():
	for pos in _every_piece_pos():
		position_updated.emit(pos.x, pos.y, true, color)

func _every_piece_pos() -> Array:
	var positions = []
	for col in range(shapes[shape_index][rotation_index].size()):
		for row in range(shapes[shape_index][rotation_index][col].size()):
			var has_shape = shapes[shape_index][rotation_index][col][row]
			if has_shape:
				positions.append(Vector2i(x + row, y + col))
	return positions
       GST2              ����                          �   RIFF�   WEBPVP8L�   /� w@ gH�m&��3�?� ��f&E՚V W�m+��ƥ�����*щ�����@A꺴�����0=��12L#��t0�L�����3i aJ�ҙ��g���U[>T    [remap]

importer="texture"
type="CompressedTexture2D"
uid="uid://b52u7eq572w1e"
path="res://.godot/imported/red.png-13f6abb0e0c70056504666ed9c349d99.ctex"
metadata={
"vram_texture": false
}
 GST2              ����                          n  RIFFf  WEBPVP8LZ  /�@I2|;���ce0+s��6��s)ݺ2*_@��R�IeU����һ�m����mI�����b�ؾ1�[̼���3���w)�>5���F5Ʀ���1��#����a0���f��f:���Z-��I�]u����x���~7M���-t�w����X6I|o~��O�����&�c���x��>K���_���1���o<��/�o��ǟ~��o����#�^dl�X�'=�q�{�$���|����w���η��i�ɶn���a7�L?Yk��_Y��j�0�������qe���~
�i��ć�;1��WSSo�7�`�����           [remap]

importer="texture"
type="CompressedTexture2D"
uid="uid://badatwvgnan1g"
path="res://.godot/imported/rightarrow.png-3566e5534ffff183538c19ac04150398.ctex"
metadata={
"vram_texture": false
}
          GST2              ����                          �  RIFF�  WEBPVP8L�  /�'c�m�㏸��aV�Xq۶q.���W�IB{xj.�`C|4@0� �X`@��� �`a@��  �,�*�i��( � ������u4aN��������ѿ�M���%D�� �]U�G&'�Z�
� ��t�k$n·���?qnLz����[�I�ui��$͠-���}w�����,C��z�J�[�SŶ�S
�ΈD6O>�Fd�H�N�yIl��&܏�_���_�gk3}���1�C��L�����R����N�7�Hk����V��I�F�S�@�ķ�R�d{7��37>�)����<:h~n����ROם���@�4�p1�
\u4�^�I�e�3>�j�ꂏ��Z�/���<�+�d��?&��ot�̪�w��� ��������Pk~?�`M��L��j��Z
�T�'��                [remap]

importer="texture"
type="CompressedTexture2D"
uid="uid://dna51njiw7vcs"
path="res://.godot/imported/rotatearrow.png-28122ee25a229600adc97ee600531be2.ctex"
metadata={
"vram_texture": false
}
         extends Node2D

var next_piece: Piece
var piece: ControlledPiece
var score: int = 0
var rows: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.start()
	
	next_piece = _new_piece()
	add_child(next_piece)
	piece = _new_controlled_piece(Piece.new())
	add_child(piece)

func _on_rows_cleared(num_rows):
	remove_child(piece)
	piece.queue_free()
	piece = _new_controlled_piece(next_piece)
	add_child(piece)

	remove_child(next_piece)
	next_piece.queue_free()
	next_piece.erase()

	next_piece = _new_piece()
	add_child(next_piece)
	
	if num_rows == 1:
		score += 100
	elif num_rows == 2:
		score += 300
	elif num_rows == 3:
		score += 500
	elif num_rows == 4:
		score += 800
	
	rows += num_rows
	
	var level: int = rows / 10
	var speed = min(level, 10)
	var timeout = 0.25 + (0.05 - 0.25) * speed / 10
	$Timer.wait_time = timeout
	
	$UI/Score.text = "Score: {0}".format([score])
	$UI/Rows.text = "Rows: {0}".format([rows])

func _game_over():
	$UI/GameOver.visible = true
	$Timer.stop()
	$FastTimer.stop()

func _new_piece() -> Piece:
	var new_piece: Piece = Piece.new()
	new_piece.position_updated.connect($NextPieceGrid._on_piece_position_updated)
	return new_piece

func _new_controlled_piece(copy_piece: Piece) -> ControlledPiece:
	var new_piece: ControlledPiece = ControlledPiece.new(copy_piece)
	new_piece.start_x = $Grid.width / 2 - 2
	new_piece.grid_path = $Grid.get_path()
	new_piece.position_updated.connect($Grid._on_piece_position_updated)
	new_piece.piece_placed.connect($Grid._on_piece_placed)
	new_piece.collision_on_entry.connect(_game_over)
	$Timer.timeout.connect(new_piece._on_game_tick)
	$FastTimer.timeout.connect(new_piece._on_fast_tick)
	return new_piece


func _on_restart_pressed():
	get_tree().change_scene_to_file("res://TitleMenu.tscn")
  RSRC                    PackedScene            ��������                                                  resource_local_to_scene    resource_name    line_spacing    font 
   font_size    font_color    outline_size    outline_color    shadow_size    shadow_color    shadow_offset    script 	   _bundled       Script    res://Tetris.gd ��������   Script    res://Grid.gd ��������   Script    res://UI.gd ��������
   Texture2D    res://rotatearrow.png J���`#p
   Texture2D    res://leftarrow.png 5�7:�O�%
   Texture2D    res://downarrow.png ��N.�Ow
   Texture2D    res://rightarrow.png ��ң�e4!      local://LabelSettings_oescm          local://LabelSettings_rx72n 9         local://LabelSettings_e5c2n {         local://PackedScene_obt5b �         LabelSettings                      LabelSettings          <                       �?         LabelSettings                      PackedScene          	         names "   <      Tetris    script    Node2D    Timer 
   wait_time 
   FastTimer 
   autostart    Grid    width    height    NextPieceGrid 	   position    UI    layout_mode    anchors_preset    offset_right    offset_bottom    Control    Rows    offset_left    offset_top    text    label_settings    Label    Score 	   GameOver    visible    PanelContainer    VBoxContainer    horizontal_alignment    Restart    Button    HBoxContainer 
   alignment    Spacer    size_flags_horizontal    Rotate    custom_minimum_size    icon    expand_icon    Spacer2    Left    Down    Right    action_mode    Spacer3    _on_rows_cleared    rows_cleared    _on_restart_pressed    pressed    _on_rotate_button_down    button_down    _on_rotate_button_up 
   button_up    _on_left_button_down    _on_left_button_up    _on_down_button_down    _on_down_button_up    _on_right_button_down    _on_right_button_up    	   variants    1                  �>)   �������?                  
         
     �C  B                         B             ��C    @D     �C    �D      Rows: 0                �C    �D    ��C     D   	   Score: 0             C     �B    � D     zC         
   Game Over                      Restart      �C     D     B      Next Piece              �)D      D    �AD
     �B�{,                  
     �B  �B         
     �B  �B               node_count             nodes     -  ��������       ����                            ����                           ����                                 ����               	                     
   ����                     	                        ����      	      
                                      ����      
                                                        ����      
                                                        ����            
                                            ����             	             ����                                	             ����            !                    ����      
      "      #      $      %      &                      ����      
      '      (      )   !                     "   ����         #   	                 $   ����   %   *         &   +   '                    (   ����         #   	                 )   ����   %   *         &   ,   '                    *   ����   %   -         &   .   '                    +   ����   %   /         ,   
   &   0   '                    -   ����         #   	             conn_count    
         conns     F          /   .                     1   0                    3   2                    5   4                    3   6                    5   7                    3   8                    5   9                    3   :                    5   ;                    node_paths              editable_instances              version             RSRC      extends Control

func _on_start_pressed():
	get_tree().change_scene_to_file("res://Tetris.tscn")


func _on_credits_button_pressed():
	$Credits.visible = true
 RSRC                    PackedScene            ��������                                                  resource_local_to_scene    resource_name    line_spacing    font 
   font_size    font_color    outline_size    outline_color    shadow_size    shadow_color    shadow_offset    script 	   _bundled       Script    res://TitleMenu.gd ��������   Script    res://Credits.gd ��������      local://LabelSettings_xf1tt �         local://PackedScene_7ivo6          LabelSettings          (            PackedScene          	         names "   .   
   TitleMenu    layout_mode    anchors_preset    anchor_right    anchor_bottom    grow_horizontal    grow_vertical    script    Control    VBoxContainer    offset_right    offset_bottom    Spacer    size_flags_vertical    Title    text    label_settings    horizontal_alignment    Label    Spacer3    Start    custom_minimum_size    size_flags_horizontal $   theme_override_font_sizes/font_size    Button 	   Controls    Spacer2    CreditsButton    Spacer4    Credits    title 	   position    size 	   max_size    ok_button_text    AcceptDialog    offset_left    offset_top    ScrollContainer    fit_content    scroll_active    autowrap_mode    RichTextLabel    _on_start_pressed    pressed    _on_credits_button_pressed    	   variants                        �?                             D     HD      Tetris                 
     C�{,                  Start          )   Controls: Left, Down, Right, Z to Rotate 
     �B�{,      Credits 
   �{,  �B-   2   2   -   �  �        Close       A     �B     tB                            node_count             nodes     �   ��������       ����                                                          	   	   ����         
                             ����                                 ����                  	      
                    ����                                 ����                                                  ����                        
                    ����                                 ����                                                  ����                           #      ����                      !      "          
       	   	   ����   $      %      
                       &   &   ����                           *      ����                       '      (      )                      conn_count             conns               ,   +                     ,   -                    node_paths              editable_instances              version             RSRC     extends Control

func _on_right_button_down():
	Input.action_press("Right")

func _on_right_button_up():
	Input.action_release("Right")

func _on_down_button_down():
	Input.action_press("Down")

func _on_down_button_up():
	Input.action_release("Down")

func _on_left_button_down():
	Input.action_press("Left")

func _on_left_button_up():
	Input.action_release("Left")

func _on_rotate_button_down():
	Input.action_press("Rotate")

func _on_rotate_button_up():
	Input.action_release("Rotate")
    [remap]

path="res://.godot/exported/133200997/export-2560527257bd42faa13afbc3e1dab95d-Tetris.scn"
             [remap]

path="res://.godot/exported/133200997/export-d2cdd72aeaa7d07fc03eff2e26d01ef4-TitleMenu.scn"
          list=Array[Dictionary]([{
"base": &"Piece",
"class": &"ControlledPiece",
"icon": "",
"language": &"GDScript",
"path": "res://ControlledPiece.gd"
}, {
"base": &"Node2D",
"class": &"Grid",
"icon": "",
"language": &"GDScript",
"path": "res://Grid.gd"
}, {
"base": &"Node2D",
"class": &"Piece",
"icon": "",
"language": &"GDScript",
"path": "res://Piece.gd"
}])
           <svg height="128" width="128" xmlns="http://www.w3.org/2000/svg"><g transform="translate(32 32)"><path d="m-16-32c-8.86 0-16 7.13-16 15.99v95.98c0 8.86 7.13 15.99 16 15.99h96c8.86 0 16-7.13 16-15.99v-95.98c0-8.85-7.14-15.99-16-15.99z" fill="#363d52"/><path d="m-16-32c-8.86 0-16 7.13-16 15.99v95.98c0 8.86 7.13 15.99 16 15.99h96c8.86 0 16-7.13 16-15.99v-95.98c0-8.85-7.14-15.99-16-15.99zm0 4h96c6.64 0 12 5.35 12 11.99v95.98c0 6.64-5.35 11.99-12 11.99h-96c-6.64 0-12-5.35-12-11.99v-95.98c0-6.64 5.36-11.99 12-11.99z" fill-opacity=".4"/></g><g stroke-width="9.92746" transform="matrix(.10073078 0 0 .10073078 12.425923 2.256365)"><path d="m0 0s-.325 1.994-.515 1.976l-36.182-3.491c-2.879-.278-5.115-2.574-5.317-5.459l-.994-14.247-27.992-1.997-1.904 12.912c-.424 2.872-2.932 5.037-5.835 5.037h-38.188c-2.902 0-5.41-2.165-5.834-5.037l-1.905-12.912-27.992 1.997-.994 14.247c-.202 2.886-2.438 5.182-5.317 5.46l-36.2 3.49c-.187.018-.324-1.978-.511-1.978l-.049-7.83 30.658-4.944 1.004-14.374c.203-2.91 2.551-5.263 5.463-5.472l38.551-2.75c.146-.01.29-.016.434-.016 2.897 0 5.401 2.166 5.825 5.038l1.959 13.286h28.005l1.959-13.286c.423-2.871 2.93-5.037 5.831-5.037.142 0 .284.005.423.015l38.556 2.75c2.911.209 5.26 2.562 5.463 5.472l1.003 14.374 30.645 4.966z" fill="#fff" transform="matrix(4.162611 0 0 -4.162611 919.24059 771.67186)"/><path d="m0 0v-47.514-6.035-5.492c.108-.001.216-.005.323-.015l36.196-3.49c1.896-.183 3.382-1.709 3.514-3.609l1.116-15.978 31.574-2.253 2.175 14.747c.282 1.912 1.922 3.329 3.856 3.329h38.188c1.933 0 3.573-1.417 3.855-3.329l2.175-14.747 31.575 2.253 1.115 15.978c.133 1.9 1.618 3.425 3.514 3.609l36.182 3.49c.107.01.214.014.322.015v4.711l.015.005v54.325c5.09692 6.4164715 9.92323 13.494208 13.621 19.449-5.651 9.62-12.575 18.217-19.976 26.182-6.864-3.455-13.531-7.369-19.828-11.534-3.151 3.132-6.7 5.694-10.186 8.372-3.425 2.751-7.285 4.768-10.946 7.118 1.09 8.117 1.629 16.108 1.846 24.448-9.446 4.754-19.519 7.906-29.708 10.17-4.068-6.837-7.788-14.241-11.028-21.479-3.842.642-7.702.88-11.567.926v.006c-.027 0-.052-.006-.075-.006-.024 0-.049.006-.073.006v-.006c-3.872-.046-7.729-.284-11.572-.926-3.238 7.238-6.956 14.642-11.03 21.479-10.184-2.264-20.258-5.416-29.703-10.17.216-8.34.755-16.331 1.848-24.448-3.668-2.35-7.523-4.367-10.949-7.118-3.481-2.678-7.036-5.24-10.188-8.372-6.297 4.165-12.962 8.079-19.828 11.534-7.401-7.965-14.321-16.562-19.974-26.182 4.4426579-6.973692 9.2079702-13.9828876 13.621-19.449z" fill="#478cbf" transform="matrix(4.162611 0 0 -4.162611 104.69892 525.90697)"/><path d="m0 0-1.121-16.063c-.135-1.936-1.675-3.477-3.611-3.616l-38.555-2.751c-.094-.007-.188-.01-.281-.01-1.916 0-3.569 1.406-3.852 3.33l-2.211 14.994h-31.459l-2.211-14.994c-.297-2.018-2.101-3.469-4.133-3.32l-38.555 2.751c-1.936.139-3.476 1.68-3.611 3.616l-1.121 16.063-32.547 3.138c.015-3.498.06-7.33.06-8.093 0-34.374 43.605-50.896 97.781-51.086h.066.067c54.176.19 97.766 16.712 97.766 51.086 0 .777.047 4.593.063 8.093z" fill="#478cbf" transform="matrix(4.162611 0 0 -4.162611 784.07144 817.24284)"/><path d="m0 0c0-12.052-9.765-21.815-21.813-21.815-12.042 0-21.81 9.763-21.81 21.815 0 12.044 9.768 21.802 21.81 21.802 12.048 0 21.813-9.758 21.813-21.802" fill="#fff" transform="matrix(4.162611 0 0 -4.162611 389.21484 625.67104)"/><path d="m0 0c0-7.994-6.479-14.473-14.479-14.473-7.996 0-14.479 6.479-14.479 14.473s6.483 14.479 14.479 14.479c8 0 14.479-6.485 14.479-14.479" fill="#414042" transform="matrix(4.162611 0 0 -4.162611 367.36686 631.05679)"/><path d="m0 0c-3.878 0-7.021 2.858-7.021 6.381v20.081c0 3.52 3.143 6.381 7.021 6.381s7.028-2.861 7.028-6.381v-20.081c0-3.523-3.15-6.381-7.028-6.381" fill="#fff" transform="matrix(4.162611 0 0 -4.162611 511.99336 724.73954)"/><path d="m0 0c0-12.052 9.765-21.815 21.815-21.815 12.041 0 21.808 9.763 21.808 21.815 0 12.044-9.767 21.802-21.808 21.802-12.05 0-21.815-9.758-21.815-21.802" fill="#fff" transform="matrix(4.162611 0 0 -4.162611 634.78706 625.67104)"/><path d="m0 0c0-7.994 6.477-14.473 14.471-14.473 8.002 0 14.479 6.479 14.479 14.473s-6.477 14.479-14.479 14.479c-7.994 0-14.471-6.485-14.471-14.479" fill="#414042" transform="matrix(4.162611 0 0 -4.162611 656.64056 631.05679)"/></g></svg>
     ��QcY��	   res://blue.png��N.�Ow   res://downarrow.png�����ӕK   res://empty.png#`qz�-�L   res://green.png����m9   res://icon.svg5�7:�O�%   res://leftarrow.png�㌟��!?   res://red.png��ң�e4!   res://rightarrow.pngJ���`#p   res://rotatearrow.pngmԃ�B   res://Tetris.tscn\���_   res://TitleMenu.tscnc4�pơ�   res://Tetris.icon.png��b18!   res://Tetris.apple-touch-icon.png�xn�{��'   res://Tetris.png   ECFG      application/config/name         Tetris     application/run/main_scene         res://TitleMenu.tscn   application/config/features(   "         4.2    GL Compatibility       application/config/icon         res://icon.svg  "   display/window/size/viewport_width      �  #   display/window/size/viewport_height         
   input/Left�              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device         	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode    @ 	   key_label             unicode           echo          script         input/Right�              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device         	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode    @ 	   key_label             unicode           echo          script         input/Rotate�              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device         	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode   Z   	   key_label             unicode           echo          script      
   input/Down�              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device         	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode    @ 	   key_label             unicode           echo          script      #   rendering/renderer/rendering_method         gl_compatibility*   rendering/renderer/rendering_method.mobile         gl_compatibility            