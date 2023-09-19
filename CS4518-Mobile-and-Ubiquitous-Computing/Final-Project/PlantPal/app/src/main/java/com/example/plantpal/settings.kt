package com.example.plantpal

import android.content.SharedPreferences
import android.media.MediaPlayer
import android.os.Bundle
import android.widget.Button
import androidx.appcompat.app.ActionBar
import androidx.appcompat.app.AppCompatActivity
import androidx.core.content.edit
import androidx.preference.PreferenceManager
import com.google.android.material.switchmaterial.SwitchMaterial

class settings : AppCompatActivity() {

    private lateinit var closeAct : Button
    private lateinit var musicToggle : SwitchMaterial

    private lateinit var musicPlayer : MediaPlayer
    private lateinit var sharedPreferences : SharedPreferences

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_settings)

        sharedPreferences = PreferenceManager.getDefaultSharedPreferences(this)

        //changes action bar display
        supportActionBar?.displayOptions = ActionBar.DISPLAY_SHOW_CUSTOM
        supportActionBar?.setCustomView(R.layout.action_bar_layout)

        closeAct = findViewById(R.id.closeActivity)
        musicToggle = findViewById(R.id.musicToggle)

        //if user switches on or off music setting
        musicToggle.setOnCheckedChangeListener { compoundButton, b ->
            if(b) {
                if(!(musicPlayer.isPlaying)) {
                    musicPlayer = MediaPlayer.create(this, R.raw.music)
                    musicPlayer.isLooping = true
                    musicPlayer.start()
                }
                sharedPreferences.edit {
                    putInt("music", 1)
                    apply()
                }
            } else {
                if(musicPlayer.isPlaying) {
                    musicPlayer.stop()
                }
                sharedPreferences.edit {
                    putInt("music", 0)
                    apply()
                }
            }
        }
            // Responds to switch being checked/unchecked

        closeAct.setOnClickListener {
            musicPlayer.stop()
            finish()
        }
    }

    override fun onResume() {
        val mus = sharedPreferences.getInt("music", 2)
        musicPlayer = MediaPlayer.create(this, R.raw.music)

        if(mus != 0) {
            musicPlayer.isLooping = true
            musicPlayer.start()
        } else {
            musicToggle.isChecked = false
        }
        super.onResume()
    }
}