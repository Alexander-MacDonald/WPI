package com.example.plantpal

import android.app.Activity
import android.content.Intent
import android.content.SharedPreferences
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.media.MediaPlayer
import android.os.Bundle
import android.provider.MediaStore
import android.util.Log
import android.widget.Button
import android.widget.ImageButton
import android.widget.ImageView
import android.widget.Toast
import androidx.appcompat.app.ActionBar
import androidx.appcompat.app.AppCompatActivity
import androidx.core.content.FileProvider
import androidx.preference.PreferenceManager
import java.io.File

private const val REQUEST_CODE = 1
private const val TAG = "AchievementActivity"
private const val PFP_FILE_NAME = "pfp.png"

class achievements : AppCompatActivity() {

    private lateinit var pfpButton : ImageButton
    private lateinit var settingsButton : ImageButton
    private lateinit var homeBtn : Button

    private lateinit var flower1 : ImageView
    private lateinit var flower2 : ImageView
    private lateinit var flower3 : ImageView
    private lateinit var flower4 : ImageView
    private lateinit var flower5 : ImageView


    private lateinit var photoFile : File
    private lateinit var pfpDirectory : File

    private lateinit var musicPlayer : MediaPlayer
    private lateinit var sharedPreferences : SharedPreferences

    private var stepAch : Int = 0

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_achievements)

        stepAch = intent.getIntExtra("stepAch", 0)

        flower1 = findViewById(R.id.flower1)
        flower2 = findViewById(R.id.flower2)
        flower3 = findViewById(R.id.flower3)
        flower4 = findViewById(R.id.flower4)
        flower5 = findViewById(R.id.flower5)

        //show flowers based on achievement level
        when (stepAch) {
            1 -> {
                flower1.setImageResource(resources.getIdentifier("ic_flower1", "drawable", packageName))
                flower2.setImageResource(resources.getIdentifier("ic_flower2", "drawable", packageName))
            }
            2 -> {
                flower1.setImageResource(resources.getIdentifier("ic_flower1", "drawable", packageName))
                flower2.setImageResource(resources.getIdentifier("ic_flower2", "drawable", packageName))
                flower3.setImageResource(resources.getIdentifier("ic_flower3", "drawable", packageName))
            }
            3 -> {
                flower1.setImageResource(resources.getIdentifier("ic_flower1", "drawable", packageName))
                flower2.setImageResource(resources.getIdentifier("ic_flower2", "drawable", packageName))
                flower3.setImageResource(resources.getIdentifier("ic_flower3", "drawable", packageName))
                flower4.setImageResource(resources.getIdentifier("ic_flower4", "drawable", packageName))
            }
            4 -> {
                flower1.setImageResource(resources.getIdentifier("ic_flower1", "drawable", packageName))
                flower2.setImageResource(resources.getIdentifier("ic_flower2", "drawable", packageName))
                flower3.setImageResource(resources.getIdentifier("ic_flower3", "drawable", packageName))
                flower4.setImageResource(resources.getIdentifier("ic_flower4", "drawable", packageName))
                flower5.setImageResource(resources.getIdentifier("ic_flower5", "drawable", packageName))
            }
            else -> {
                flower1.setImageResource(resources.getIdentifier("ic_flower1", "drawable", packageName))
            }
        }

        sharedPreferences = PreferenceManager.getDefaultSharedPreferences(this)

        //changes action bar display
        supportActionBar?.displayOptions = ActionBar.DISPLAY_SHOW_CUSTOM
        supportActionBar?.setCustomView(R.layout.action_bar_layout)

        pfpButton = findViewById(R.id.pfpButton)
        settingsButton = findViewById(R.id.settingsButton)
        homeBtn = findViewById(R.id.homeBtn)
        pfpDirectory = File(this.applicationContext.filesDir, "cs4518_photos")

        photoFile = getPhotoFile(PFP_FILE_NAME)

        if(photoFile.exists()) {
            val image = BitmapFactory.decodeFile(photoFile.absolutePath)
            pfpButton.setImageBitmap(Bitmap.createScaledBitmap(image, 200, 200, false))
        }

        //allow user to set profile picture from this page as well
        pfpButton.setOnClickListener {
            musicPlayer.stop()

            val takePictureIntent = Intent(MediaStore.ACTION_IMAGE_CAPTURE)
            photoFile = getPhotoFile(PFP_FILE_NAME)

            val fileProvider = FileProvider.getUriForFile(this, "com.example.plantpal.fileprovider", photoFile)

            takePictureIntent.putExtra(MediaStore.EXTRA_OUTPUT, fileProvider)

            if(takePictureIntent.resolveActivity(this.packageManager) != null) {
                startActivityForResult(takePictureIntent, REQUEST_CODE)
            } else {
                Toast.makeText(this, "Unable to open Camera", Toast.LENGTH_SHORT).show()
            }
        }

        //send back to home page
        homeBtn.setOnClickListener {
            musicPlayer.stop()
            finish()
        }

        //change settings
        settingsButton.setOnClickListener {
            val i = Intent(this, settings::class.java)
            if(musicPlayer.isPlaying) {
                musicPlayer.stop()
            }
            startActivity(i)
        }
    }

    override fun onResume() {
        val mus = sharedPreferences.getInt("music", 2)
        musicPlayer = MediaPlayer.create(this, R.raw.music)

        if(mus != 0) {
            musicPlayer.isLooping = true
            musicPlayer.start()
        }
        super.onResume()
    }

    private fun getPhotoFile(fileName : String): File {
        return File(pfpDirectory, fileName)
    }

    //returns new photo and updates app screen & scales it to fit in the corner.
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        if(requestCode == REQUEST_CODE && resultCode == Activity.RESULT_OK) {
            val image = BitmapFactory.decodeFile(photoFile.absolutePath)
            pfpButton.setImageBitmap(Bitmap.createScaledBitmap(image, 200, 200, false))
        } else {
            super.onActivityResult(requestCode, resultCode, data)
        }
    }
}