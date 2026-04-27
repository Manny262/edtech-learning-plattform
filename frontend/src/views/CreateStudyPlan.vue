<template>
    <main>
        <div id="form-generator">
            <form action="POST" @submit.prevent="MakeStudyPlan()">
                <div>
                    <div>
                        <label for="subject">Fagområde:</label>
                        <input id="subject" v-model="inp.subject" type="text" placeholder="Samfunnskunnskap" required />
                    </div>
                    <div>
                        <label for="level">Nivå:</label>
                        <input id="level" v-model="inp.level" type="text" placeholder="Yrkesfag" required />
                    </div>
                    <div>
                        <label for="topic">Tema:</label>
                        <input id="topic" v-model="inp.topic" type="text" placeholder="Velferdsstaten" required />
                    </div>
                    <div>
                        <label for="exam_date">Dato for prøve / eksamen:</label>
                        <input id="exam_date" v-model="inp.exam_date" type="date" required />
                    </div>
                    <div>
                        <label for="test_type">Tema:</label>
                        <input id="test_type" v-model="inp.test_type" type="text" placeholder="fagsamtale" required />
                    </div>
                    <div>
                        <label for="language">Språk:</label>
                        <input id="language" v-model="inp.language" type="text" placeholder="Norsk" required />
                    </div>
                </div>
                <div><button type="submit"><span>lag study plan</span></button></div>
            </form>
            <br>
            <section v-if="data">
                <div>
                    <li>{{ data.study_plan.subject }}</li>
                    <li>{{ data.study_plan.level }}</li>
                    <li>{{ data.study_plan.topic }}</li>
                    <li>{{ data.study_plan.exam_date }}</li>
                    <li>{{ data.study_plan.test_type }}</li>
                    <li>{{ data.study_plan.generated_date }}</li>
                    <li>{{ data.study_plan.language }}</li>
                </div>
                <br>
                <div>
                    <h2>Flashcards:</h2>
                    <div v-for="(set, key) in data.study_plan.flashcards" :key="key">
                        <h3>Set: {{ key }}</h3>
                        <div v-for="(card, i) in set" :key="i" style=" margin-bottom: 1rem;">
                            <label for="{{ i }}">Spørsmål: {{ i + 1 }}</label>
                            <textarea name="{{ i }}" id="" v-model="card.question_text"
                                style="width: 100%; resize: vertical">
                            </textarea>
                            <br>
                            <label for="{{ i }}">svar:</label>
                            <textarea name="{{ i }}" id="" v-model="card.answer_text" style="width: 100%; resize: vertical;"
                                rows="5">do not remove this!
                            </textarea>

                        </div>
                    </div>
                </div>
                <br>
                <div>
                    <h2>Multiple Choice:</h2>
                    <div v-for="(mc, i) in data.study_plan.multiple_choice" :key="i">
                        <label for="{{ i }}">Spørsmål: {{ i }}</label>
                        <textarea name="{{ i }}" id="" v-model="mc.question_text" style="width: 100%; resize: vertical">
                        do not remove this!
                        </textarea>
                        <p>riktig svar: {{ mc.correct_answer_index + 1 }} </p>
                        <div v-for="(options, x) in mc.options" :key="x">
                            <label for="{{ x + 1 }}">{{ x + 1 }}</label>
                            <textarea name="{{ x + 1 }}" id="" v-model="mc.options[x]"
                                style="width: 100%; resize: vertical">do not remove this!</textarea>

                        </div>

                    </div>
                </div>
                <br>
                <div>
                    <p v-for="(day, i) in data.study_plan.days" :key="i">{{ day.scheduled_date }}: {{ day.focus_area }}</p>
                </div>
            </section>
            <!-- <pre>{{ data.study_plan.flashcards }}</pre>
            <pre>{{ data.study_plan.multiple_choice }}</pre> -->
            <button @click.prevent="postStudyPlan()" type="submit">Lag studieplan</button>
        </div>
    </main>
</template>
<script>
import axios from 'axios';
export default {
    data() {
        return {
            data:  {
  "study_plan": {
    "subject": "Naturfag",
    "grade": "Yrkesfag",
    "topic": "Bølger og akkustikk",
    "exam_date": "2026-05-03",
    "test_type": "Skriftlig prøve",
    "test_type_id": "1",
    "generated_date": "2026-04-27",
    "language": "Norsk",
    "flashcards": {
      "1": [
        {
          "question_text": "Hva er en bølge?",
          "answer_text": "En bølge er en forstyrrelse som beveger seg gjennom et medium og overfører energi uten å flytte materie permanent."
        },
        {
          "question_text": "Hva er forskjellen mellom transversale og langsgående bølger?",
          "answer_text": "Transversale bølger vibrerer vinkelrett på bevegelsesretningen (f.eks. lysbølger), mens langsgående bølger vibrerer parallelt med bevegelsesretningen (f.eks. lydbølger)."
        },
        {
          "question_text": "Definer bølgelengde.",
          "answer_text": "Bølgelengde er avstanden mellom to påfølgende toppunkter eller bunnpunkter i en bølge. Den måles i meter (m)."
        },
        {
          "question_text": "Hva er frekvens?",
          "answer_text": "Frekvens er antall svingninger eller bølger per sekund. Den måles i Hertz (Hz)."
        },
        {
          "question_text": "Hva er amplitude?",
          "answer_text": "Amplitude er den maksimale forskyvningen fra likevektsstillingen. Den beskriver bølgens styrke eller intensitet."
        }
      ],
      "2": [
        {
          "question_text": "Hva er sammenhengen mellom bølgehastighet, frekvens og bølgelengde?",
          "answer_text": "v = f × λ, hvor v er bølgehastighet (m/s), f er frekvens (Hz) og λ er bølgelengde (m)."
        },
        {
          "question_text": "Hva er lydhastigheten i luft ved romtemperatur?",
          "answer_text": "Lydhastigheten i luft ved romtemperatur (20°C) er omtrent 343 m/s."
        },
        {
          "question_text": "Hva er akustikk?",
          "answer_text": "Akustikk er læren om lyd, inkludert hvordan lyd produseres, forplanter seg, og oppfattes."
        },
        {
          "question_text": "Hvordan påvirker temperaturen lydhastigheten?",
          "answer_text": "Lydhastigheten øker med økende temperatur fordi molekylene beveger seg raskere og overfører energi mer effektivt."
        },
        {
          "question_text": "Hva er refleksjon av lydbølger?",
          "answer_text": "Refleksjon er når lydbølger treffer en overflate og kastes tilbake. Dette skaper ekko når refleksjonen er merkbar."
        }
      ],
      "3": [
        {
          "question_text": "Hva er resonans?",
          "answer_text": "Resonans oppstår når et objekt vibrerer med sin naturlige frekvens som respons på ytre svingninger, noe som gir forsterket amplitude."
        },
        {
          "question_text": "Hva er interferens?",
          "answer_text": "Interferens er når to eller flere bølger møtes og kombineres. Konstruktiv interferens forsterker bølgene, mens destruktiv interferens svekker dem."
        },
        {
          "question_text": "Hva er Doppler-effekten?",
          "answer_text": "Doppler-effekten er endringen i observert frekvens når kilden eller observatøren beveger seg. Frekvensen øker ved tilnærming og minker ved fjerning."
        },
        {
          "question_text": "Hva måles lydstyrke i?",
          "answer_text": "Lydstyrke måles i desibel (dB), som er en logaritmisk skala for lydintensitet."
        },
        {
          "question_text": "Hva er stående bølger?",
          "answer_text": "Stående bølger oppstår når to bølger med samme frekvens og amplitude beveger seg i motsatte retninger og interfererer, og skaper faste knutepunkter og bukker."
        }
      ]
    },
    "multiple_choice": [
      {
        "question_text": "Hvilken type bølge er lydbølger?",
        "options": [
          "Transversale bølger",
          "Langsgående bølger",
          "Elektromagnetiske bølger",
          "Overflatebølger"
        ],
        "correct_answer_index": 1
      },
      {
        "question_text": "Hva er enheten for frekvens?",
        "options": [
          "Meter (m)",
          "Sekund (s)",
          "Hertz (Hz)",
          "Desibel (dB)"
        ],
        "correct_answer_index": 2
      },
      {
        "question_text": "Hvis en bølge har frekvens 100 Hz og bølgelengde 2 m, hva er bølgehastigheten?",
        "options": [
          "50 m/s",
          "100 m/s",
          "200 m/s",
          "400 m/s"
        ],
        "correct_answer_index": 2
      },
      {
        "question_text": "Hva skjer med lydhastigheten når temperaturen øker?",
        "options": [
          "Den minker",
          "Den øker",
          "Den forblir konstant",
          "Den blir null"
        ],
        "correct_answer_index": 1
      },
      {
        "question_text": "Hva kalles fenomenet når lydbølger kastes tilbake fra en overflate?",
        "options": [
          "Refraksjon",
          "Diffraksjon",
          "Refleksjon",
          "Absorpsjon"
        ],
        "correct_answer_index": 2
      },
      {
        "question_text": "Hvilken av disse faktorene påvirker IKKE lydhastigheten i et medium?",
        "options": [
          "Temperatur",
          "Mediumets tetthet",
          "Mediumets elastisitet",
          "Lydkildens amplitude"
        ],
        "correct_answer_index": 3
      },
      {
        "question_text": "Hva beskriver amplituden til en lydbølge?",
        "options": [
          "Tonehøyden",
          "Lydstyrken",
          "Lydhastigheten",
          "Bølgelengden"
        ],
        "correct_answer_index": 1
      },
      {
        "question_text": "Når oppstår konstruktiv interferens?",
        "options": [
          "Når bølger møtes i motsatt fase",
          "Når bølger møtes i samme fase",
          "Når bølger har forskjellig frekvens",
          "Når bølger reflekteres"
        ],
        "correct_answer_index": 1
      },
      {
        "question_text": "Hva er perioden til en bølge med frekvens 50 Hz?",
        "options": [
          "0,01 s",
          "0,02 s",
          "0,05 s",
          "0,1 s"
        ],
        "correct_answer_index": 1
      },
      {
        "question_text": "Hvilken påstand om Doppler-effekten er riktig?",
        "options": [
          "Frekvensen minker når lydkilden nærmer seg",
          "Frekvensen øker når lydkilden fjerner seg",
          "Frekvensen øker når lydkilden nærmer seg",
          "Frekvensen påvirkes ikke av bevegelse"
        ],
        "correct_answer_index": 2
      }
    ],
    "days": [
      {
        "scheduled_date": "2026-04-27",
        "focus_area": "Grunnleggende bølgekonsepter",
        "tasks": {
          "Task 1": {
            "description": "Les gjennom teori om hva bølger er, forskjellen mellom transversale og langsgående bølger, og grunnleggende bølgeterminologi (amplitude, frekvens, bølgelengde)."
          },
          "Task 2": {
            "description": "Gjennomgå flashcards om grunnleggende bølgekonsepter.",
            "type": "Flashcards",
            "set_number": 1
          },
          "Task 3": {
            "description": "Løs de tre første flervalgsspørsmålene for å teste forståelsen av bølgetyper og frekvens."
          }
        }
      },
      {
        "scheduled_date": "2026-04-28",
        "focus_area": "Bølgeligningen og lydhastighet",
        "tasks": {
          "Task 1": {
            "description": "Studer bølgeligningen v = f × λ og øv på beregninger med ulike verdier for frekvens og bølgelengde."
          },
          "Task 2": {
            "description": "Lær om lydhastighet i forskjellige medier og hvordan temperatur påvirker lydhastigheten.",
            "type": "Flashcards",
            "set_number": 2
          },
          "Task 3": {
            "description": "Løs øvingsoppgaver med beregning av bølgehastighet, frekvens og bølgelengde."
          }
        }
      },
      {
        "scheduled_date": "2026-04-29",
        "focus_area": "Akustikk og lydbølger",
        "tasks": {
          "Task 1": {
            "description": "Studer akustikk: hvordan lyd produseres, forplanter seg og påvirkes av mediet den beveger seg gjennom."
          },
          "Task 2": {
            "description": "Gjennomgå flashcards om akustikk, refleksjon og lydhastighet.",
            "type": "Flashcards",
            "set_number": 2
          },
          "Task 3": {
            "description": "Løs flervalgsspørsmål 4-6 om temperaturens effekt på lydhastighet og refleksjon."
          }
        }
      },
      {
        "scheduled_date": "2026-04-30",
        "focus_area": "Bølgefenomener: Interferens og resonans",
        "tasks": {
          "Task 1": {
            "description": "Studer interferens (konstruktiv og destruktiv), resonans og stående bølger. Se på eksempler og illustrasjoner."
          },
          "Task 2": {
            "description": "Gjennomgå flashcards om resonans, interferens og stående bølger.",
            "type": "Flashcards",
            "set_number": 3
          },
          "Task 3": {
            "description": "Lag egne eksempler på hvor interferens og resonans forekommer i hverdagen."
          }
        }
      },
      {
        "scheduled_date": "2026-05-01",
        "focus_area": "Doppler-effekten og lydstyrke",
        "tasks": {
          "Task 1": {
            "description": "Studer Doppler-effekten grundig: hva som skjer når lydkilden eller observatøren beveger seg, og praktiske eksempler."
          },
          "Task 2": {
            "description": "Lær om lydstyrke, desibel-skalaen og hvordan amplitude påvirker lydstyrken.",
            "type": "Flashcards",
            "set_number": 3
          },
          "Task 3": {
            "description": "Løs flervalgsspørsmål 7-10 om amplitude, interferens og Doppler-effekten."
          }
        }
      },
      {
        "scheduled_date": "2026-05-02",
        "focus_area": "Repetisjon og fullstendig gjennomgang",
        "tasks": {
          "Task 1": {
            "description": "Gjennomgå alle flashcards fra sett 1, 2 og 3 for full repetisjon av alle temaer."
          },
          "Task 2": {
            "description": "Løs alle flervalgsspørsmålene på nytt og identifiser områder som trenger mer oppmerksomhet.",
            "type": "Flashcards",
            "set_number": 1
          },
          "Task 3": {
            "description": "Lag et sammendrag av de viktigste formlene, definisjonene og konseptene. Skriv ned eksempler på hver type bølgefenomen."
          },
          "Task 4": {
            "description": "Øv på å forklare bølgekonsepter med egne ord som om du skulle lære det til noen andre."
          }
        }
      },
      {
        "scheduled_date": "2026-05-03",
        "focus_area": "Eksamensdagen - siste forberedelser",
        "tasks": {
          "Task 1": {
            "description": "Les raskt gjennom sammendraget ditt og de viktigste formlene på morgenen."
          },
          "Task 2": {
            "description": "Gå gjennom noen få utvalgte flashcards for å friske opp hukommelsen rett før eksamen.",
            "type": "Flashcards",
            "set_number": 2
          },
          "Task 3": {
            "description": "Ta med deg nødvendig utstyr (kalkulator, skrivesaker) og sørg for å være uthvilt og rolig. Lykke til!"
          }
        }
      }
    ]
  }
}

,
            inp: {
                subject: '',
                level: '',
                topic: '',
                exam_date: '',
                test_type: '',
                language: ''
            }
        }
    },
    methods: {
        async MakeStudyPlan() {
            const form = new FormData()
            form.append('subject', this.inp.subject)
            form.append('level', this.inp.level)
            form.append('topic', this.inp.topic)
            form.append('exam_date', this.inp.exam_date)
            form.append('test_type', this.inp.test_type)
            form.append('language', this.inp.language)
            try {
                const res = await axios.post('/api/study-plan/generate/', form)
                this.data = res.data
                console.log(this.data)
            }
            catch (error) {
                console.error(error)
            }
        },
        async postStudyPlan(){
            try{
                const res = await axios.post('/api/study-plan/save/', this.data)
                console.log(res.status)
            }catch(error){
                console.error(error)
            }
        }


    }
}
</script>

<style scoped>
main {
    /* grid-column: 1 / -1; */
    padding-top: 5rem;
    width: 100vw;
    box-sizing: border-box;

}

#form-generator {
    max-width: 100vw;
    margin: 0 auto;
    padding: 4rem;
}
</style>