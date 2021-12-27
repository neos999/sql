DECLARE @item_id VARCHAR(200), @group_id VARCHAR(200);
SET @item_id = '07c3970c-2c95-4895-941e-d1151cd9f631';
SET @group_id = '9998b5ec-2722-4d75-bb21-34a297f04490';


select id, cfg_item_group, characteristics, characteristic_values, char_code, char_code_start_position, char_code_end_position, char_value_name, char_value_name_group_position, comment, 
	case when 
	(
		select count(*) from 
		(
			select ID
			from  openjson( (Select characteristics from cfg_group_char_attributes as group_inner where group_inner.id = group_outer.id),'$') 
			with 
			(
				ID VARCHAR(200) '$.id'
			)
			as json_char

			intersect
			select characteristic from cfg_item_characteristics where cfg_item = @item_id
		) I
	) > 0
	then 1 else 0 end
	as item_has_char
	from cfg_group_char_attributes as group_outer
	where cfg_item_group = @group_id
	and characteristics not in
	(
		Select characteristics from cfg_item_char_attributes where cfg_item = @item_id 
	)
;
