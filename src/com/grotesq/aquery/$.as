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
 *  @since		Jul 19, 2013
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

package com.grotesq.aquery
{
	/**
	 * AQuery 객체를 생성해 반환합니다.
	 * String으로 된 표현식을 전달할 때엔 반드시 AQuery.initialize( stage ) 된 이후여야 합니다.
	 * 전역적으로 동작하는 AQuery.find()와 같은 역할을 합니다.
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
	 * AQuery는 대부분의 메소드가 메소드 체인을 지원합니다.
	 * 따라서 $()를 변수에 대입해 사용할 수도 있지만, 메소드 체인을 이용해 바로 다음 동작을 기술할 수도 있습니다.
	 * 다음 샘플 코드를 참조해보세요.
	 *
	 * @example 이 코드는 Flash Professional IDE를 기준으로 설명되는 내용입니다 :
 * <listing version="3.0">
 * import com.grotesq.aquery.$;
 * import com.grotesq.aquery.AQuery;
 * 
 * // 현재 타임라인을 기준으로 하는 AQuery 객체를 생성하고, BlendMode를 지정합니다.
 * var aquery:Aquery = $( this );
 * aquery.blendMode = "multiply";
 * // 참조하는 객체를 생성하지 않고 바로 기술할 수 있습니다.
 * $( this ).blendMode = "multiply";
 * </listing>
	 * 
	 * @param $selector	표현식, 혹은 객체
	 * 
	 * @see com.grotesq.aquery.AQuery
	 */
	public function $( $selector:Object ):AQuery
	{
		if( $selector is AQuery )
		{
			return $selector as AQuery;
		}
		else
		{
			return AQuery.find( $selector );
		}
	}
}