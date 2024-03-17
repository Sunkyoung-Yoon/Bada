package com.ssafy.bada

import android.os.Bundle
import android.widget.FrameLayout
import androidx.appcompat.app.AppCompatActivity
import com.skt.Tmap.TMapView


class TMapActivity : AppCompatActivity() {

    val API_KEY = "HTKgFHNpvf3Xts15E9MGh9g2pKX3laAW1bPgRlYj" // 발급받은 API 키

    var tmapView: TMapView? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        setContentView(R.layout.activity_tmap)

        tmapView = TMapView(this)

        val container = findViewById<FrameLayout>(R.id.tmapContainer)
        container.addView(tmapView)

        tmapView?.setSKTMapApiKey(API_KEY)

//        tMapView?.setOnMapReadyListener(object : TMapView.OnMapReadyListener {
//            override fun onMapReady() {
//                //todo 맵 로딩 완료 후 구현
//            }
//        })
//
//        // 클릭 이벤트 설정
//        tMapView?.setOnClickListenerCallback(object : TMapView.OnClickListenerCallback {
//            override fun onPressDown(arrayList: ArrayList<*>, arrayList1: ArrayList<*>, tMapPoint: TMapPoint, pointF: PointF) {
//                Toast.makeText(this@MainActivity, "onPressDown", Toast.LENGTH_SHORT).show()
//            }
//
//            override fun onPressUp(arrayList: ArrayList<*>, arrayList1: ArrayList<*>, tMapPoint: TMapPoint, pointF: PointF) {
//                Toast.makeText(this@MainActivity, "onPressUp", Toast.LENGTH_SHORT).show()
//            }
//        })
    }


}