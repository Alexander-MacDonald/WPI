package com.example.plantpal

//Please Read attached README.txt for clarification between emulator program & physical device

//comment out for emulator compilation
/*
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
 */
//end
import android.app.Activity
import android.content.Intent
import android.content.SharedPreferences
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.media.MediaPlayer
import android.os.Bundle
import android.provider.MediaStore
import android.widget.*
import androidx.appcompat.app.ActionBar
import androidx.appcompat.app.AppCompatActivity
import androidx.core.content.FileProvider
import androidx.core.content.edit
import androidx.preference.PreferenceManager
import java.io.File

private const val REQUEST_CODE = 1
private const val TAG = "MainActivity"
private const val PFP_FILE_NAME = "pfp.png"

//use if device has step count sensor
//class MainActivity : AppCompatActivity(), SensorEventListener {
//use if emulator
class MainActivity : AppCompatActivity() {

    private lateinit var pfpButton : ImageButton
    private lateinit var settingsButton : ImageButton
    private lateinit var achieveBtn : Button
    private lateinit var devStep : Button
    private lateinit var flower : ImageView

    private lateinit var progressBar : ProgressBar
    private lateinit var progressBarText : TextView

    private lateinit var pfpDirectory : File
    private lateinit var photoFile : File

    //comment out for emulator compilation
    /*
    private lateinit var sMan : SensorManager
    private lateinit var stepSensor : Sensor
     */
    //end

    private lateinit var musicPlayer : MediaPlayer
    private lateinit var sharedPreferences : SharedPreferences

    private var steps : Int = 0 //# steps user has taken
    private var stepAch : Int = 0 //current achievement level the user is at

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)


        sharedPreferences = PreferenceManager.getDefaultSharedPreferences(this)

        // RESET VALUES
        //Uncomment to reset sharedPreferences
        /*
        val editor: SharedPreferences.Editor = sharedPreferences.edit()
        editor.clear()
        editor.apply()
        */
        //end

        //Comment for Emulator Compilation
        /*
        sMan = getSystemService(SENSOR_SERVICE) as SensorManager
        stepSensor = sMan.getDefaultSensor(Sensor.TYPE_STEP_COUNTER)
         */
        //end

        //changes action bar display
        supportActionBar?.displayOptions = ActionBar.DISPLAY_SHOW_CUSTOM
        supportActionBar?.setCustomView(R.layout.action_bar_layout)

        pfpButton = findViewById(R.id.pfpButton)
        settingsButton = findViewById(R.id.settingsButton)
        progressBar = findViewById(R.id.progressBar)
        progressBarText = findViewById(R.id.progressBarText)
        achieveBtn = findViewById(R.id.achieveBtn)
        devStep = findViewById(R.id.devStep)
        flower = findViewById(R.id.flower)

        //Logic for setting up directories/reloading image in the directory on new startup
        //for data persistence
        pfpDirectory = File(this.applicationContext.filesDir, "cs4518_photos")
        // creates the directory if not present yet & first time setup so set sharedPreferences for music
        if (!pfpDirectory.exists()) {
            // true if and only if the directory was created; false otherwise
            pfpDirectory.mkdir()
            //extra functionality for base music
        }


        //music logic w/ sharedPreferences
        val mus = sharedPreferences.getInt("music", 2)
        stepAch = sharedPreferences.getInt("stepAch", -1)
        steps = sharedPreferences.getInt("steps", -1)

        if (mus == 2) {
            //first run, add music preference (music on)
            sharedPreferences.edit {
                putInt("music", 1)
                apply()
            }
        }

        if(stepAch == -1) {
            //first run, add achievement level preference (level 0)
            sharedPreferences.edit {
                putInt("stepAch", 0)
                apply()
            }
            stepAch = 0
        }

        if(steps == -1) {
            //first run, add steps preference (0 steps)
            sharedPreferences.edit {
                putInt("steps", 0)
                apply()
            }
        }

        //instantiate user data
        steps = sharedPreferences.getInt("steps", 0)
        stepAch = sharedPreferences.getInt("stepAch", 0)


        //set home screen flower based on level
        setFlower()

        //set progress bar based on # of steps
        updateProgressBar()

        //get pfp if it exists.
        photoFile = getPhotoFile(PFP_FILE_NAME)

        if(photoFile.exists()) {
            val image = BitmapFactory.decodeFile(photoFile.absolutePath)
            pfpButton.setImageBitmap(Bitmap.createScaledBitmap(image, 200, 200, false))
        }

        //when PFP is clicked, user is prompted to take a new pfp photo
        pfpButton.setOnClickListener {
            if(musicPlayer.isPlaying) {
                musicPlayer.stop()
            }

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

        //send to plants page
        achieveBtn.setOnClickListener {
            val i = Intent(this, achievements::class.java)
            i.putExtra("stepAch", stepAch)
            if(musicPlayer.isPlaying){
                musicPlayer.stop()
            }
            startActivity(i)
        }

        //send to settings page
        settingsButton.setOnClickListener {
            val i = Intent(this, settings::class.java)
            if(musicPlayer.isPlaying) {
                musicPlayer.stop()
            }
            startActivity(i)
        }

        devStep.setOnClickListener {
            incrementSteps(1)
            updateProgressBar()
        }
    }

    override fun onResume() {
        //sMan.registerListener(this, stepSensor, SensorManager.SENSOR_DELAY_NORMAL);
        val mus = sharedPreferences.getInt("music", 2)
        musicPlayer = MediaPlayer.create(this, R.raw.music)

        if(mus != 0) {
            musicPlayer.isLooping = true
            musicPlayer.start()
        }
        super.onResume()
    }

    //returns photoFile location
    private fun getPhotoFile(fileName : String): File{
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

    private fun updateProgressBar() {
        val x: Int = ((steps.toDouble() / (stepSteps[stepAch]).toDouble()) * 100).toInt()
        progressBar.setProgress(x, true)
        progressBarText.text = steps.toString() + " / " + stepSteps[stepAch].toString()
    }

    //Comment Out for Emulator Compilation
    /*
    override fun onSensorChanged(p0: SensorEvent?) {
        incrementSteps(p0?.values!![0].toInt())
        updateProgressBar()
    }
     */
    //end

    //Comment Out for Emulator Compilation
    /*
    override fun onAccuracyChanged(p0: Sensor?, p1: Int) {
    }
     */
    //end


    private fun setFlower() {
        when(stepAch) {
            1 -> flower.setImageResource(resources.getIdentifier("ic_flower2", "drawable", packageName))            1 -> flower.setImageResource(resources.getIdentifier("ic_flower2.xml", "drawable", packageName))
            2 -> flower.setImageResource(resources.getIdentifier("ic_flower3", "drawable", packageName))
            3 -> flower.setImageResource(resources.getIdentifier("ic_flower4", "drawable", packageName))
            4 -> flower.setImageResource(resources.getIdentifier("ic_flower5", "drawable", packageName))
            else -> flower.setImageResource(resources.getIdentifier("ic_flower1", "drawable", packageName))
        }
    }

    private fun incrementSteps(n : Int) {
        if (steps + n >= stepSteps[stepAch]) {
            steps = 0
            stepAch++
            setFlower()
            Toast.makeText(this, "Congratulations", Toast.LENGTH_SHORT).show()
            sharedPreferences.edit {
                putInt("steps", steps)
                putInt("stepAch", stepAch)
                apply()
            }
        } else {
            steps += n
            sharedPreferences.edit {
                putInt("steps", steps)
                apply()
            }
        }
    }
}

