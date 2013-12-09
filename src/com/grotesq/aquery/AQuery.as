////////////////////////////////////////////////////////////////////////////////
//
//  The GrotesQ
//  Copyright 2005-2013 The GrotesQ
//  All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////

/**
 * 	@author		Kim Naram (a.k.a. Unknown), unknown@grotesq.com, http://grotesq.com
 * 	@version	v.1.0
 *  @since		Jul 1, 2013
 */

/**
 * 	ACTIONSCRIPT VERSION: 3.0
 * 
 * 	DESCRIPTION:
 * 
 * 	NOTES:
 * 
 * 	CHANGE LOG:
 *	
 */

package com.grotesq.aquery {
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.system.ApplicationDomain;
	import flash.utils.getDefinitionByName;
	
	/**
	 * AS3용 Display List 도우미입니다.<br />
	 * JS에서 document를 기준으로 DOM에 접근을 하듯, AS에서 stage를 기준으로 Display List를 탐색하는데 도움을 줍니다.<br />
	 * Flash Professional에서 UI를 구성했을 때나, 부모 자식 관계가 복잡한 리스트를 가지고 작업할 때 도움이 됩니다.<br />
	 * 
	 * @see com.grotesq.aquery.$
	 * @see "편리한 사용을 위해 이 함수에 대해서 알아보세요."
	 * 
	 */
	public final class AQuery
	{
		////////////////////////////////////////////////////////////////////////////////
		//
		//	Class Constants
		//
		////////////////////////////////////////////////////////////////////////////////
		
		public static const VERSION:String = "0.0.4";
		
		////////////////////////////////////////////////////////////////////////////////
		//
		//	Class Variables
		//
		////////////////////////////////////////////////////////////////////////////////
		
		private static var _stage:Stage;
		
		////////////////////////////////////////////////////////////////////////////////
		//
		//	Class Properties
		//
		////////////////////////////////////////////////////////////////////////////////
		
		////////////////////////////////////////////////////////////////////////////////
		//
		//	Class Public Methods
		//
		////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * AQuery를 초기화 합니다.
		 * AQuery.find 메소드를 전역적으로 실행할 때 문자열 형태의 표현식을 사용하기 위해서는 반드시 초기화를 해야 합니다.
		 * NativeWindow가 여러개 존재하는 AIR 애플리케이션의 경우 각각의 stage에 대한 낱개의 AQuery 객체를 생성해 사용할 수도 있습니다.
		 *  
		 * 
		 * @param stage stage 객체입니다.
		 * @example
		 * <listing version="3.0">
		 * import com.grotesq.aquery.AQuery;
		 * 
		 * AQuery.initialize( stage );
		 * // or
		 * var $:AQuery = AQuery.initialize( stage );
		 * </listing>
		 */
		public static function initialize( $stage:Stage ):AQuery
		{
			_stage = $stage;
			return new AQuery( _stage );
		}
		
		/**
		 * 로그를 출력합니다.
		 * 오버라이드 해서 원하는 다른 로거를 연결할 수 있습니다.
		 * 기본 로거는 trace로 되어있습니다.
		 */
		public static function log( ...args ):void
		{
			trace.apply( null, args );
		}
		
		/**
		 * AQuery 객체를 생성해 반환합니다. 표현식이나 디스플레이 객체를 전달할 수 있습니다.
		 * 표현식을 이용하기 위해서는 AQuery.initialize 메소드가 선행되어야 합니다. 
		 * 
		 * @param $selector 표현식 또는 디스플레이 객체입니다.
		 */
		public static function find( $selector:Object ):AQuery
		{
			if( $selector is String )
			{
				if( _stage == null )
				{
					AQuery.log( "Not initialized. Can't found stage." );
					return new AQuery( null );
				}
				return new AQuery( _stage ).find( String( $selector ) );
			}
			else
			{
				return new AQuery( $selector );
			}
		}
		
		////////////////////////////////////////////////////////////////////////////////
		//
		//	Constants
		//
		////////////////////////////////////////////////////////////////////////////////
		
		private const RESERVED:Array = 	[
			"DisplayObject",
			"DisplayObjectContainer",
			"InteractiveObject",
			"Shape",
			"Bitmap",
			"SimpleButton",
			"Loader",
			"Sprite",
			"MovieClip",
			"Video",
			"TextField"
		];
		
		////////////////////////////////////////////////////////////////////////////////
		//
		//	Variables
		//
		////////////////////////////////////////////////////////////////////////////////
		
		////////////////////////////////////////////////////////////////////////////////
		//
		//	Instance Properties
		//
		////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * 표현식으로 탐색해 찾은 객체들입니다.
		 */
		public var objects:Vector.<DisplayObject>;
		
		////////////////////////////////////////////////////////////////////////////////
		//
		//	Constructor
		//
		////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * AQuery 객체를 생성합니다.
		 * String으로 된 표현식을 전달할 땐 반드시 AQuery.initialize( stage ) 된 이후여야 합니다.
		 * 
		 * $selector에 전달할 수 있는 값은 다음과 같습니다.
		 * 
		 * 	<ul>
		 * 		<li>stage</li>
		 * 		<li>DisplayObject</li>
		 * 		<li>Vector.&lt;DisplayObject&gt;</li>
		 * 		<li>AQuery</li>
		 * 		<li>String</li>
		 * 	</ul> 
		 * 
		 * @param $selector 표현식 또는 디스플레이 객체입니다.
		 */
		public function AQuery( $selector:Object )
		{
			if( $selector == null )
			{
				AQuery.log( "Object is null" );
			}
			else if( $selector is AQuery )
			{
				objects = ( $selector as AQuery ).objects.concat();
			}
			else if( $selector is DisplayObject )
			{
				objects = new Vector.<DisplayObject>();
				objects.push( $selector );
			}
			else if( $selector is String )
			{
				find( $selector as String );
			}
			else if( $selector is Vector.<DisplayObject> )
			{
				objects = $selector as Vector.<DisplayObject>;
			}
			else
			{
				AQuery.log( "unknown type : " + $selector );
			}
		}
		
		////////////////////////////////////////////////////////////////////////////////
		//
		//	Instance Properties
		//
		////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * AQuery 객체가 제어하고 있는 디스플레이 객체의 개수입니다.
		 */
		public function get length():int
		{
			return objects ? objects.length : 0;
		}
		
		/**
		 * AQuery 객체를 생성하는데 사용한 표현식입니다.
		 * 디스플레이 객체를 직접 전달해 생성한 경우 null을 반환합니다.
		 */
		protected var _selector:String;
		public function get selector():String
		{
			return _selector;
		}
		
		/*
		* Display Object Properties
		*/
		
		/**
		 * DisplayObject의 alpha 속성과 동일합니다.
		 */
		public function get alpha():Number
		{
			return objects.length ? objects[ 0 ].alpha : NaN;
		}
		public function set alpha( $value:Number ):void
		{
			attr( { alpha: $value} );
		}
		
		/**
		 * DisplayObject의 blendMode 속성과 동일합니다.
		 */
		public function get blendMode():String
		{
			return objects.length ? objects[ 0 ].blendMode : null;
		}
		public function set blendMode( $value:String ):void
		{
			attr( { blendMode: $value } );
		}
		
		/**
		 * DisplayObject의 filters 속성과 동일합니다.
		 */
		public function get filters():Array
		{
			return objects.length ? objects[ 0 ].filters : null;
		}
		public function set filters( $value:Array ):void
		{
			attr( { filters: $value } );
		}
		
		/**
		 * DisplayObject의 height 속성과 동일합니다.
		 */
		public function get height():Number
		{
			return objects.length ? objects[ 0 ].height : NaN;
		}
		public function set height( $value:Number ):void
		{
			attr( { height: $value } );
		}
		
		/**
		 * DisplayObject의 rotation 속성과 동일합니다.
		 */
		public function get rotation():Number
		{
			return objects.length ? objects[ 0 ].rotation : NaN;
		}
		public function set rotation( $value:Number ):void
		{
			attr( { rotation: $value } );
		}
		
		/**
		 * DisplayObject의 rotationX 속성과 동일합니다.
		 */
		public function get rotationX():Number
		{
			return objects.length ? objects[ 0 ].rotationX : NaN;
		}
		public function set rotationX( $value:Number ):void
		{
			attr( { rotationX: $value } );
		}
		
		/**
		 * DisplayObject의 rotationY 속성과 동일합니다.
		 */
		public function get rotationY():Number
		{
			return objects.length ? objects[ 0 ].rotationY : NaN;
		}
		public function set rotationY( $value:Number ):void
		{
			attr( { rotationY: $value } );
		}
		
		/**
		 * DisplayObject의 rotationZ 속성과 동일합니다.
		 */
		public function get rotationZ():Number
		{
			return objects.length ? objects[ 0 ].rotationZ : NaN;
		}
		public function set rotationZ( $value:Number ):void
		{
			attr( { rotationZ: $value } );
		}
		
		/**
		 * DisplayObject의 scaleX 속성과 동일합니다.
		 */
		public function get scaleX():Number
		{
			return objects.length ? objects[ 0 ].scaleX : NaN;
		}
		public function set scaleX( $value:Number ):void
		{
			attr( { scaleX: $value } );
		}
		
		/**
		 * DisplayObject의 scaleY 속성과 동일합니다.
		 */
		public function get scaleY():Number
		{
			return objects.length ? objects[ 0 ].scaleY : NaN;
		}
		public function set scaleY( $value:Number ):void
		{
			attr( { scaleY: $value } );
		}
		
		/**
		 * DisplayObject의 scaleZ 속성과 동일합니다.
		 */
		public function get scaleZ():Number
		{
			return objects.length ? objects[ 0 ].scaleZ : NaN;
		}
		public function set scaleZ( $value:Number ):void
		{
			attr( { scaleZ: $value } );
		}
		
		/**
		 * scaleX와 scaleY를 동시에 제어합니다.
		 */
		public function get scale():Number
		{
			var obj:DisplayObject = objects[ 0 ];
			if( obj )
			{
				if( obj.scaleX == obj.scaleY )
				{
					return obj.scaleX;
				}
				else
				{
					return NaN;
				}
			}
			else
			{
				return NaN;
			}
		}
		public function set scale( $value:Number ):void
		{
			attr( { scaleX: $value, scaleY: $value } );
		}
		
		/**
		 * DisplayObject의 visible 속성과 동일합니다.
		 */
		public function get visible():Boolean
		{
			return objects.length ? objects[ 0 ].visible : false;
		}
		public function set visible( $value:Boolean ):void
		{
			attr( { visible: $value } );
		}
		
		/**
		 * DisplayObject의 width 속성과 동일합니다.
		 */
		public function get width():Number
		{
			return objects.length ? objects[ 0 ].width : NaN;
		}
		public function set width( $value:Number ):void
		{
			attr( { width: $value } );
		}
		
		/**
		 * DisplayObject의 x 속성과 동일합니다.
		 */
		public function get x():Number
		{
			return objects.length ? objects[ 0 ].x : NaN;
		}
		public function set x( $value:Number ):void
		{
			attr( { x: $value } );
		}
		
		/**
		 * DisplayObject의 y 속성과 동일합니다.
		 */
		public function get y():Number
		{
			return objects.length ? objects[ 0 ].y : NaN;
		}
		public function set y( $value:Number ):void
		{
			attr( { y: $value } );
		}
		
		/**
		 * DisplayObject의 z 속성과 동일합니다.
		 */
		public function get z():Number
		{
			return objects.length ? objects[ 0 ].z : NaN;
		}
		public function set z( $value:Number ):void
		{
			attr( { z: $value } );
		}
		
		/**
		 * MovieClip의 currentFrame을 get/set 방식으로 읽고 쓸 수 있습니다.
		 * Tween API등에서 유용하게 사용할 수 있습니다.
		 */
		public function get frame():int
		{
			if( objects[ 0 ] )
			{
				if( objects[ 0 ] is MovieClip )
				{
					return MovieClip( objects[ 0 ] ).currentFrame;
				}
			}
			return NaN;
		}
		public function set frame( $value:int ):void
		{
			gotoAndStop( $value );
		}
		
		/**
		 * alpha를 조정하고 alpha가 0이 되었을 때 visible을 false로 설정합니다.
		 * Tween API등에서 유용하게 사용할 수 있습니다.
		 */
		public function get autoAlpha():Number
		{
			return alpha;
		}
		public function set autoAlpha( $value:Number ):void
		{
			attr( { alpha: $value } );
			if( $value == 0 )
			{
				attr( { visible: false } );
			}
			else
			{
				attr( { visible: true } );
			}
		}
		
		////////////////////////////////////////////////////////////////////////////////
		//
		//	Private Methods
		//
		////////////////////////////////////////////////////////////////////////////////
		
		private function attrAction( $index:int, $element:DisplayObject, $key:String, $value:* ):void
		{
			if( $element.hasOwnProperty( $key ) )
			{
				$element[ $key ] = $value;
			}
		}
		
		private function getClassPath( $className:String ):String
		{
			if( RESERVED.indexOf( $className ) != -1 )
			{
				switch( $className )
				{
					case'TextField':
						$className = 'flash.text.TextField';
						break;
					case'Video':
						$className = 'flash.media.Video';
						break;
					default:
						$className = 'flash.display.' + $className;
						break;
				}
			}
			return $className;
		}
		
		/**
		 * 디스플레이 객체가 표현식에 해당하는지 여부를 검사합니다.
		 * 
		 * @param $object 검사할 디스플레이 객체
		 * @param $query 검사할 표현식
		 * @return 유효할 경우에만 반환
		 */
		private function parseObject( $object:DisplayObject, $query:String ):DisplayObject
		{
			if( $query == null )
			{
				return null;
			}
			
			if( $object == null )
			{
				return null;
			}
			
			switch( $query.charAt( 0 ) )
			{
				case "#" :
				{
					if( $object.name == $query.substr( 1 ) )
					{
						return $object;
					}
					break;
				}
				case "/" :
				{
					var reg:RegExp = new RegExp( $query.substr( 1, $query.length - 2 ), "ig" );
					if( reg.test( $object.name ) )
					{
						return $object;
					}
					break;
				}
				default :
				{
					var additionalIndex:int = -1;
					var additionalQuery:String;
					if( $query.indexOf( "#" ) > 0 )
					{
						additionalIndex = $query.indexOf( "#" );
						additionalQuery = $query.substr( additionalIndex );
						$query = $query.substr( 0, additionalIndex );
					}
					else if( $query.indexOf( "/" ) > 0 )
					{
						additionalIndex = $query.indexOf( "/" );
						additionalQuery = $query.substr( additionalIndex, $query.length - additionalIndex );
						$query = $query.substr( 0, additionalIndex );
					}
					
					$query = getClassPath( $query );
					
					if( ApplicationDomain.currentDomain.hasDefinition( $query ) )
					{
						var cls:Class = Class( ApplicationDomain.currentDomain.getDefinition( $query ) );
						if( $object is cls )
						{
							if( additionalQuery )
							{
								return parseObject( $object, additionalQuery );
							}
							else
							{
								return $object;
							}
							
						}
					}
				}
			}
			return null;
		}
		
		/**
		 * 부모 디스플레이 컨테이너 객체에서 표현식에 맞는 자식 객체를 탐색합니다.
		 */
		private function getChildren( $parent:DisplayObjectContainer, $result:Vector.<DisplayObject>, $depth:int ):void
		{
			if( $parent == null )
			{
				return;
			}
			
			var queries:Array = _selector.split( " " );
			var query:String = queries[ $depth ];
			
			for( var i:int = 0, len:int = $parent.numChildren; i < len; i++ )
			{
				var object:DisplayObject = $parent.getChildAt( i );
				var parseResult:DisplayObject = parseObject( object, query );
				var depth:int = parseResult ? $depth + 1 : $depth;
				if( queries.length == 1 )
				{
					depth = 0;
				}
				getChildren( object as DisplayObjectContainer, $result, depth );
				if( $depth == queries.length - 1 && parseResult != null )
				{
					$result.push( parseResult );
				}
			}
		}
		
		////////////////////////////////////////////////////////////////////////////////
		//
		//	Protected Methods
		//
		////////////////////////////////////////////////////////////////////////////////
		
		////////////////////////////////////////////////////////////////////////////////
		//
		//	Public Methods
		//
		////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * 반복 처리를 위한 함수입니다.
		 * 인덱스를 기준으로 반복처리를 할 수 있습니다.
		 * 콜백 함수는 인덱스와 해당 인덱스의 객체 두개를 반드시 인자로 받아야 합니다.
		 * @example :
		 * 
		 */
		public function eachApply( $function:Function, ...args ):AQuery
		{
			var list:Vector.<DisplayObject> = objects;
			for( var i:int = 0, len:int = list ? list.length : 0; i < len; i++ )
			{
				var object:Object = list[ i ];
				var param:Array = [ i, object ];
				$function.apply( null, param.concat( args ) );
			}
			return this;
		}
		
		/**
		 * 표현식에 해당하는 자식 객체를 탐색해서 새 AQuery 객체를 반환합니다.
		 * 문자열 표현식만 사용할 수 있습니다.
		 */
		public function find( $query:String, ...args ):AQuery
		{
			var parent:Vector.<DisplayObject>;
			if( objects )
			{
				parent = objects;
			}
			else
			{
				parent = new Vector.<DisplayObject>();
				parent.push( AQuery._stage );
			}
			
			if( args[ 0 ] )
			{
				$query += " " + args.join( " " );
			}
			
			_selector = $query;
			var result:Vector.<DisplayObject> = new Vector.<DisplayObject>();
			
			for( var i:int = 0, len:int = parent.length; i < len; i++ )
			{
				getChildren( parent[ i ] as DisplayObjectContainer, result, 0 );
			}
			
			if( objects )
			{
				return new AQuery( result );
			}
			else
			{
				objects = result;
				return this;
			}
		}
		
		/**
		 * 속성을 지정할 수 있습니다.
		 * 단일 속성을 지정할 수도 있고, Object 형태로 여러 속성을 지정할 수도 있습니다.
		 */
		public function attr( ...args ):AQuery
		{
			if( args[ 0 ] is String )
			{
				eachApply( attrAction, args[ 0 ], args[ 1 ] );
			}
			else if( args[ 0 ] is Object )
			{
				for( var key:String in args[ 0 ] )
				{
					eachApply( attrAction, key, args[ 0 ][ key ] );
				}
			}
			return this;
		}
		
		/**
		 * 인자로 전달된 객체가 선택된 객체들 중에 있으면 인덱스를 반환합니다.
		 */
		public function index( $object:* ):int
		{
			var index:int = -1;
			for( var i:int = 0, len:int = objects.length; i < len; i++ )
			{
				if( objects[ i ] === $object )
				{
					index = i;
				}
			}
			return index;
		}
		
		/**
		 * 선택된 객체들의 부모 객체를 포함하는 새 AQuery 객체를 반환합니다.
		 */
		public function parent():AQuery
		{
			var result:Vector.<DisplayObject> = new Vector.<DisplayObject>();
			for( var i:int = 0, len:int = objects.length; i < len; i++ )
			{
				if( objects[ i ].parent )
				{
					result.push( objects[ i ].parent );
				}
			}
			return new AQuery( result );
		}
		
		/**
		 * 선택된 객체들의 자식 객체를 모두 포함한 새 AQuery 객체를 반환합니다.
		 */
		public function children():AQuery
		{
			var result:Vector.<DisplayObject> = new Vector.<DisplayObject>();
			for( var i:int = 0, len:int = objects.length; i < len; i++ )
			{
				if( objects[ i ] is DisplayObjectContainer )
				{
					var object:DisplayObjectContainer = objects[ i ] as DisplayObjectContainer;
					for( var j:int = 0, innerLen:int = object.numChildren; j < innerLen; j++ )
					{
						result.push( object.getChildAt( j ) );
					}
				}
			}
			return new AQuery( result );
		}
		
		/**
		 * EventDispatcher의 addEventListener를 구현하는 함수입니다.
		 */
		public function addEvent( $type:String, $listener:Function, $useCapture:Boolean = false, $priority:int = 0, $useWeakReference:Boolean = false ):void
		{
			eachApply( function( $index:int, $element:DisplayObject ):void {
				$element.addEventListener( $type, $listener, $useCapture, $priority, $useWeakReference );
			} );
		}
		
		/**
		 * EventDispatcher의 removeEventListener를 구현하는 함수입니다.
		 */
		public function removeEvent( $type:String, $listener:Function, $useCapture:Boolean = false ):void
		{
			eachApply( function( $index:int, $element:DisplayObject ):void {
				$element.removeEventListener( $type, $listener, $useCapture );
			} );
		}
		
		/**
		 * EventDispatcher의 dispatchEvent를 구현하는 함수입니다.
		 */
		public function triggerEvent( $event:Event ):void
		{
			eachApply( function( $index:int, $element:DisplayObject ):void {
				if( $element is InteractiveObject )
				{
					( $element as InteractiveObject ).dispatchEvent( $event );
				}
			} );
		}
		
		/**
		 * MouseEvent.MOUSE_DOWN에 대한 유틸리티 함수입니다.
		 * 콜백 함수는 이벤트 모델 규칙을 따르도록 작성되어야 합니다.
		 */
		public function mousedown( ...args ):AQuery
		{
			if( args[ 0 ] )
			{
				addEvent( MouseEvent.MOUSE_DOWN, args[ 0 ] );
			}
			else
			{
				triggerEvent( new MouseEvent( MouseEvent.MOUSE_DOWN ) );
			}
			return this;
		}
		
		/**
		 * MouseEvent.MOUSE_UP에 대한 유틸리티 함수입니다.
		 * 콜백 함수는 이벤트 모델 규칙을 따르도록 작성되어야 합니다.
		 */
		public function mouseup( ...args ):AQuery
		{
			if( args[ 0 ] )
			{
				addEvent( MouseEvent.MOUSE_UP, args[ 0 ] );
			}
			else
			{
				triggerEvent( new MouseEvent( MouseEvent.MOUSE_UP ) );
			}
			return this;
		}
		
		/**
		 * MouseEvent.MOUSE_MOVE에 대한 유틸리티 함수입니다.
		 * 콜백 함수는 이벤트 모델 규칙을 따르도록 작성되어야 합니다.
		 */
		public function mousemove( ...args ):AQuery
		{
			if( args[ 0 ] )
			{
				addEvent( MouseEvent.MOUSE_MOVE, args[ 0 ] );
			}
			else
			{
				triggerEvent( new MouseEvent( MouseEvent.MOUSE_MOVE ) );
			}
			return this;
		}
		
		/**
		 * MouseEvent.ROLL_OVER 대한 유틸리티 함수입니다.
		 * 콜백 함수는 이벤트 모델 규칙을 따르도록 작성되어야 합니다.
		 */
		public function rollover( ...args ):AQuery
		{
			if( args[ 0 ] )
			{
				addEvent( MouseEvent.ROLL_OVER, args[ 0 ] );
			}
			else
			{
				triggerEvent( new MouseEvent( MouseEvent.ROLL_OVER ) );
			}
			return this;
		}
		
		/**
		 * MouseEvent.ROLL_OUT 대한 유틸리티 함수입니다.
		 * 콜백 함수는 이벤트 모델 규칙을 따르도록 작성되어야 합니다.
		 */
		public function rollout( ...args ):AQuery
		{
			if( args[ 0 ] )
			{
				addEvent( MouseEvent.ROLL_OUT, args[ 0 ] );
			}
			else
			{
				triggerEvent( new MouseEvent( MouseEvent.ROLL_OUT ) );
			}
			return this;
		}
		
		/**
		 * MouseEvent.CLICK에 대한 유틸리티 함수입니다.
		 * 콜백 함수는 이벤트 모델 규칙을 따르도록 작성되어야 합니다.
		 */
		public function click( ...args ):AQuery
		{
			if( args[ 0 ] )
			{
				addEvent( MouseEvent.CLICK, args[ 0 ] );
			}
			else
			{
				triggerEvent( new MouseEvent( MouseEvent.CLICK ) );
			}
			return this;
		}
		
		/**
		 * addEvent()와 동일합니다. jQuery 타입의 코드 구현을 원한다면 유용합니다.
		 * EventDispatcher의 addEventListener를 구현하는 함수입니다.
		 */
		public function on( $type:String, $listener:Function, $useCapture:Boolean = false, $priority:int = 0, $useWeakReference:Boolean = false ):AQuery
		{
			addEvent( $type, $listener, $useCapture, $priority, $useWeakReference );
			return this;
		}
		
		/**
		 * removeEvent()와 동일합니다. jQuery 타입의 코드 구현을 원한다면 유용합니다.
		 * EventDispatcher의 removeEventListener를 구현하는 함수입니다.
		 */
		public function off( $type:String, $listener:Function, $useCapture:Boolean = false ):AQuery
		{
			removeEvent( $type, $listener, $useCapture );
			return this;
		}
		
		/**
		 * 탐색한 객체에 무비클립이 있을 경우 gotoAndPlay 명령을 수행할 수 있습니다.
		 */
		public function gotoAndPlay( $frame:Object, $scene:String = null ):AQuery
		{
			eachApply( function( $index:int, $element:DisplayObject ):void {
				if( $element.hasOwnProperty( "gotoAndPlay" ) )
				{
					Object( $element ).gotoAndPlay( $frame, $scene );
				}
			} );
			return this;
		}
		
		/**
		 * 탐색한 객체에 무비클립이 있을 경우 gotoAndStop 명령을 수행할 수 있습니다.
		 */
		public function gotoAndStop( $frame:Object, $scene:String = null ):AQuery
		{
			eachApply( function( $index:int, $element:DisplayObject ):void {
				if( $element.hasOwnProperty( "gotoAndStop" ) )
				{
					Object( $element ).gotoAndStop( $frame, $scene );
				}
			} );
			return this;
		}
		
		/**
		 * 탐색한 객체에 무비클립이 있을 경우 play 명령을 수행할 수 있습니다.
		 */
		public function play():AQuery
		{
			eachApply( function( $index:int, $element:DisplayObject ):void {
				if( $element.hasOwnProperty( "play" ) )
				{
					Object( $element ).play();
				}
			} );
			return this;
		}
		
		/**
		 * 탐색한 객체에 무비클립이 있을 경우 stop 명령을 수행할 수 있습니다.
		 */
		public function stop():AQuery
		{
			eachApply( function( $index:int, $element:DisplayObject ):void {
				if( $element.hasOwnProperty( "stop" ) )
				{
					Object( $element ).stop();
				}
			} );
			return this;
		}
		
		/**
		 * 부모 컨테이너를 찾아 removeChild를 수행합니다.
		 */
		public function remove():AQuery	
		{
			eachApply( function( $index:int, $element:DisplayObject ):void {
				if( $element.parent )
				{
					$element.parent.removeChild( $element );
				}
			} );
			return this;
		}
		
		/**
		 * 클래스 경로나 클래스 자체를 전달해 객체를 새로 생성합니다.
		 * $name 인수로 이름을 미리 지정하면 나중에 활용하기 편리합니다.
		 */
		public function create( $element:Object, $name:String = null ):AQuery
		{
			var definition:Class;
			var object:DisplayObject;
			
			if( $element is String )
			{
				$element = getClassPath( String( $element ) );
				
				definition = getDefinitionByName( String( $element ) ) as Class;
				if( definition )
				{
					object = new definition();
				}
			}
			else if( $element is Class )
			{
				definition = $element as Class;
				object = new definition();
			}
			
			if( object )
			{
				if( $name )
				{
					object.name = $name;
				}
				
				append( DisplayObject( object ) );
			}
			return this;
		}
		
		/**
		 * addChild와 비슷한 기능을 합니다.
		 * $element는 DisplayObject일 수도 있고, AQuery 객체일 수도 있습니다.
		 * $name을 지정하면 나중에 활용할 때 편리합니다.
		 */
		public function append( $element:Object, $name:String = null ):AQuery
		{
			if( objects[ 0 ] )
			{
				if( objects[ 0 ] is DisplayObjectContainer )
				{
					if( $element is AQuery )
					{
						AQuery( $element ).eachApply( function( $index:int, $el:DisplayObject ):void {
							if( $name )
							{
								$el.name = $name;
							}
							DisplayObjectContainer( objects[ 0 ] ).addChild( $el );
						} );
					}
					else if( $element is DisplayObject )
					{
						if( $name )
						{
							$element.name = $name;
						}
						DisplayObjectContainer( objects[ 0 ] ).addChild( DisplayObject( $element ) );
					}
				}
			}
			return this;
		}
		
		/**
		 * AS2의 duplicateMovieClip과 비슷한 역할을 합니다.
		 * 객체의 클래스를 찾아 새로 생성하기 때문에, 생성 이후의 변화 상태가 완전하게 복제되지 않을 수 있습니다.
		 */
		public function duplicate( $source:DisplayObject ):AQuery
		{
			var sourceClass:Class = Object( $source ).constructor;
			var duplicate:DisplayObject = new sourceClass();
			
			duplicate.transform = $source.transform;
			duplicate.filters = $source.filters;
			duplicate.cacheAsBitmap = $source.cacheAsBitmap;
			duplicate.opaqueBackground = $source.opaqueBackground;
			
			if( $source.scale9Grid)
			{
				var rect:Rectangle = $source.scale9Grid;
				duplicate.scale9Grid = rect;
			}
			if( $source.hasOwnProperty( "graphics" ) && duplicate.hasOwnProperty( "graphics" ) )
			{
				Object( duplicate ).graphics.copyFrom( Object( $source ).graphics );
			}
			
			return AQuery.find( duplicate );
		}
		
		/**
		 * 특정 인덱스의 raw object를 얻을 수 있습니다.
		 */
		public function getItem( $index:int ):DisplayObject
		{
			if( objects[ $index ] )
			{
				return objects[ $index ];
			}
			return null;
		}
	}
}
