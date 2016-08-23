package map;

import massive.munit.Assert;
import degen.map.Map2d;
import degen.map.MapHelper;

class MapHelperTest {
  var map : Map2d;

  @Before
  public function setup(){
    map = new Map2d(8,8,0);
  }

  @Test
  public function get_first_empty_of_0_on_0_filled_map_should_return_non_null_tile() {
    var firstEmpty = MapHelper.getFirstEmptyTile(map, 0);
    Assert.isTrue(firstEmpty != null);
  }
  
  @Test
  public function get_first_empty_of_1_on_0_filled_map_should_return_null() {
    var firstEmpty = MapHelper.getFirstEmptyTile(map, 1);
    Assert.isTrue(firstEmpty == null);
  }

  @Test
  public function get_first_empty_of_0_on_random_0_1_filled_map_should_return_non_null_tile() {
    map.fillMapRandomly(1,0,50);
    var firstEmpty = MapHelper.getFirstEmptyTile(map, 0);
    Assert.isTrue(firstEmpty != null);
  }

  @Test
  public function get_first_empty_of_1_on_manually_filled_array_without_ignore_array_should_return_non_null() {
    map.set(0,0,1);

    var firstEmpty = MapHelper.getFirstEmptyTile(map, 1);
    Assert.isTrue(firstEmpty != null);
  }

  @Test
  public function get_first_empty_of_1_on_manually_filled_array_with_ignore_array_should_return_null() {
    map.set(0,0,1);

    var ignore = map.IndexToXY(0);
    var ignoreArray = new Array<Tile2d>();

    ignoreArray.push(ignore);

    var firstEmpty = MapHelper.getFirstEmptyTile(map, 1, ignoreArray);
    Assert.isTrue(firstEmpty == null);
  }

  @Test
  public function floodfill_on_0_filled_map_should_return_array_same_as_map_size(){
    var filledTiles = MapHelper.floodFill(map, 0, 0, 0);

    Assert.areEqual(map._mapData.length, filledTiles.length);
  }
  
  @Test
  public function floodfill_on_manually_filled_map_should_return_top_row(){
    map.set(0,1,1);
    map.set(1,1,1);
    map.set(2,1,1);
    map.set(3,1,1);
    map.set(4,1,1);
    map.set(5,1,1);
    map.set(6,1,1);
    map.set(7,1,1);

    var filledTiles = MapHelper.floodFill(map, 0, 0, 0);

    //should flood fill only first row
    Assert.areEqual(8, filledTiles.length);
  }

  @Test
  public function floodfill_on_manually_filled_map_should_all_but_top_two_rows(){
    map.set(0,1,1);
    map.set(1,1,1);
    map.set(2,1,1);
    map.set(3,1,1);
    map.set(4,1,1);
    map.set(5,1,1);
    map.set(6,1,1);
    map.set(7,1,1);

    var filledTiles = MapHelper.floodFill(map, 2, 2, 0);

    //should flood fill all but first and second row first row
    Assert.areEqual(48, filledTiles.length);
  }

  @Test
  public function floodfill_with_diagonal_on_manually_filled_map_should_all_but_already_filled(){
    map.set(2,0,1);
    map.set(1,1,1);
    map.set(0,2,1);

    var filledTiles = MapHelper.floodFill(map, 2, 2, 0, true);

    //should fill all, including top left corner
    Assert.areEqual(61, filledTiles.length);
  }

  @Test
  public function floodfill_no_diagonal_on_manually_filled_map_should_all_but_top_left_corner(){
    map.set(2,0,1);
    map.set(1,1,1);
    map.set(0,2,1);

    var filledTiles = MapHelper.floodFill(map, 2, 2, 0, false);
   
    //should fill all but top left corner
    Assert.areEqual(58, filledTiles.length);
  }

  @Test
  public function isMapConnected_no_diagonal_on_manually_filled_map_should_return_false(){
    map.set(2,0,1);
    map.set(1,1,1);
    map.set(0,2,1);

    var connected = MapHelper.isMapConnected(map, 0, false);

    Assert.isFalse(connected);
  }

  @Test
  public function isMapConnected_with_diagonal_on_manually_filled_map_should_return_true(){
    map.set(2,0,1);
    map.set(1,1,1);
    map.set(0,2,1);

    var connected = MapHelper.isMapConnected(map, 0, true);

    Assert.isTrue(connected);
  }

  @Test
  public function isMapConnected_on_manually_filled_map_should_return_false_with_all_but_top_two_rows(){
    map.set(0,1,1);
    map.set(1,1,1);
    map.set(2,1,1);
    map.set(3,1,1);
    map.set(4,1,1);
    map.set(5,1,1);
    map.set(6,1,1);
    map.set(7,1,1);

    var connected = MapHelper.isMapConnected(map);

    //should flood fill all but first and second row first row
    Assert.isFalse(connected);
  }

}
